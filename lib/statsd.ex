defmodule StatsD do
  def record({:counter, name, count}) do
    {:ok, pid} = find_or_create(name)

    StatsD.Metric.Counter.append(pid, String.to_integer(count))
  end

  def record(text) do
    Task.async fn ->
      case text |> String.trim() |> String.split("|") do
        [name] ->
          record({:counter, name, 1})
        [name, "c"] ->
          record({:counter, name, 1})
        [name, "c", count] ->
          record({:counter, name, count})
      end
    end
  end

  def find_or_create(tag) do
    case Registry.lookup(StatsD.Registry, tag) do
      [{pid, _}] ->
        {:ok, pid}
      _ ->
        name = {:via, Registry, {StatsD.Registry, tag}}
        DynamicSupervisor.start_child(StatsD.Metric.Supervisor, {StatsD.Metric.Counter, name})
    end
  end
end
