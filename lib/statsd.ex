defmodule StatsD do
  def record({:counter, name, count}) do
    {:ok, pid} = find_or_create(StatsD.Metric.Counter, name)

    StatsD.Metric.Counter.append(pid, count)
  end

  def record({:set, name, count}) do
    {:ok, pid} = find_or_create(StatsD.Metric.Set, name)

    StatsD.Metric.Set.append(pid, count)
  end

  def record_text(text) do
    text
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.each(&record_line_async/1)
  end

  defp record_line_async(text) do
    Task.async(fn -> record_line(text) end)
  end

  defp record_line(""), do: nil
  defp record_line(text) do
    text
    |> StatsD.Parser.parse()
    |> record()
  end

  defp find_or_create(mod, tag) do
    case Registry.lookup(StatsD.Registry, tag) do
      [{pid, _}] ->
        {:ok, pid}

      _ ->
        name = {:via, Registry, {StatsD.Registry, tag}}
        DynamicSupervisor.start_child(StatsD.Metric.Supervisor, {mod, name})
    end
  end
end
