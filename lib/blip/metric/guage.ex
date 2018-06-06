defmodule Blip.Metric.Guage do
  use GenServer

  def start_link(name = {:via, Registry, {Blip.Registry, tag}}) do
    state = %{
      tag: tag,
      value: 0
    }

    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(state) do
    period = Application.get_env(:blip, :flush_period)

    :timer.send_interval(period, :flush)

    {:ok, state}
  end

  def handle_cast(value, state) do
    {:noreply, %{state | value: value}}
  end

  def handle_info(:flush, state) do
    Blip.Backend.persist({state.tag, :guage, state.value})

    {:noreply, state}
  end
end
