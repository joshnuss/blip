defmodule StatsD.Metric.Counter do
  use GenServer

  @period 1000

  def start_link(name = {:via, Registry, {StatsD.Registry, tag}}) do
    state = %{
      tag: tag,
      sum: 0
    }

    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(state) do
    :timer.send_interval(@period, :flush)

    {:ok, state}
  end

  def handle_cast(n, state) do
    {:noreply, %{state | sum: state.sum + n}}
  end

  def handle_info(:flush, state) do
    StatsD.Backend.persist({state.tag, :counter, state.sum})

    {:noreply, %{state | sum: 0}}
  end

  def append(tag, value) do
    GenServer.cast(tag, value)
  end
end
