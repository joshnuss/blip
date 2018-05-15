defmodule Gather.Backend do
  use GenServer

  @name __MODULE__

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: @name)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:persist, metric}, state) do
    IO.inspect(metric)

    {:noreply, state}
  end

  def persist(metric) do
    GenServer.cast(@name, {:persist, metric})
  end
end
