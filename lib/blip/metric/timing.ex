defmodule Blip.Metric.Timing do
  use GenServer

  def start_link(name = {:via, Registry, {Blip.Registry, tag}}) do
    state = %{
      tag: tag,
      values: []
    }

    GenServer.start_link(__MODULE__, state, name: name)
  end

  def init(state) do
    period = Application.get_env(:blip, :flush_period)

    :timer.send_interval(period, :flush)

    {:ok, state}
  end

  def handle_cast(n, state) do
    {:noreply, %{state | values: [n|state.values]}}
  end

  def handle_info(:flush, state=%{values: []}) do
    report = %{
      min: 0,
      max: 0,
      sum: 0,
      average: 0,
    }

    Blip.Backend.persist({state.tag, :timing, report})

    {:noreply, state}
  end

  def handle_info(:flush, state=%{values: values}) do
    sum = Enum.sum(values)
    count =  Enum.count(values)

    report = %{
      min: Enum.min(values),
      max: Enum.max(values),
      sum: sum,
      average: (if count > 0, do: ( sum / count ), else: 0)
    }

    Blip.Backend.persist({state.tag, :timing, report})

    {:noreply, %{state | values: []}}
  end
end
