defmodule Blip do
  @types %{
    counter: Blip.Metric.Counter,
    guage: Blip.Metric.Guage,
    set: Blip.Metric.Set,
    timing: Blip.Metric.Timing,
  }

  def record({type, name, count, tags}) do
    module = @types[type]

    {:ok, pid} = find_or_create(module, name)

    GenServer.cast(pid, count)
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
    |> Blip.Parser.parse()
    |> record()
  end

  defp find_or_create(mod, tag) do
    case Registry.lookup(Blip.Registry, tag) do
      [{pid, _}] ->
        {:ok, pid}

      _ ->
        name = {:via, Registry, {Blip.Registry, tag}}
        case DynamicSupervisor.start_child(Blip.Metric.Supervisor, {mod, name}) do
          {:ok, pid} ->
            {:ok, pid}

          {:error, {:already_started, pid}} ->
            {:ok, pid}
        end
    end
  end
end
