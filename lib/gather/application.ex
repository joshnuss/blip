defmodule Gather.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Gather.UDPServer, 2052},
      {Registry, keys: :unique, name: Gather.Registry}
    ]

    opts = [strategy: :one_for_one, name: Gather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
