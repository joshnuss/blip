defmodule StatsD do
  def record({:counter, name, count}) do
    {:ok, pid} = find_or_create(name)

    StatsD.Metric.Counter.append(pid, count)
  end

  def record_text(text) do
    text
    |> String.split("\n")
    |> Enum.each(&record_line_async/1)
  end

  defp record_line_async(text) do
    Task.async(fn -> record_line(text) end)
  end

  defp record_line(""), do: nil
  defp record_line(text) do
    case text |> String.trim() |> String.split("|") do
      [kv] ->
        {bucket, value} = parse(kv)

        record({:counter, bucket, value})

      [kv, "c"] ->
        {bucket, value} = parse(kv)

        record({:counter, bucket, value})

      [kv, "c", _sample_rate] ->
        {bucket, value} = parse(kv)

        record({:counter, bucket, value})
    end
  end

  defp find_or_create(tag) do
    case Registry.lookup(StatsD.Registry, tag) do
      [{pid, _}] ->
        {:ok, pid}

      _ ->
        name = {:via, Registry, {StatsD.Registry, tag}}
        DynamicSupervisor.start_child(StatsD.Metric.Supervisor, {StatsD.Metric.Counter, name})
    end
  end

  defp parse(kv) do
    case String.split(kv, ":") do
      [bucket] -> {bucket, 1}
      [bucket, value] -> {bucket, String.to_integer(value)}
    end
  end
end
