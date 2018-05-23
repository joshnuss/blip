defmodule StatsD.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = sockets ++ [
      {Registry, keys: :unique, name: StatsD.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: StatsD.Metric.Supervisor},
      {StatsD.Backend, []}
    ]

    opts = [strategy: :one_for_one, name: StatsD.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp sockets do
    Application.get_env(:statsd, :port)
    |> List.wrap
    |> Enum.map(&Supervisor.child_spec({StatsD.UDPServer, &1}, id: &1))
  end
end
