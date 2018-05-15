defmodule Gather.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Gather.UDPServer, 2052},
    ]

    opts = [strategy: :one_for_one, name: Gather.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
