defmodule Gather.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Gather.UDPServer, 2052},
      {Registry, keys: :unique, name: Gather.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: Gather.Metric.Supervisor},
      {Gather.Backend, []}
    ]

    opts = [strategy: :one_for_one, name: Gather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
