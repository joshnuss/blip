defmodule StatsD.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {StatsD.UDPServer, 2052},
      {Registry, keys: :unique, name: StatsD.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: StatsD.Metric.Supervisor},
      {StatsD.Backend, []}
    ]

    opts = [strategy: :one_for_one, name: StatsD.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
