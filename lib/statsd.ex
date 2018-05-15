defmodule StatsD do
  def record({:counter, name, count}) do
    IO.puts "recording stat"
  end

  def record(text) do
    Task.async fn ->
      case String.split(text, "|") do
        [name] ->
          record({:counter, name, 1})
        [name, "c"] ->
          record({:counter, name, 1})
        [name, "c", count] ->
          record({:counter, name, count})
      end
    end
  end
end
