defmodule Blip.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = sockets() ++ [
      {Registry, keys: :unique, name: Blip.Registry},
      {DynamicSupervisor, strategy: :one_for_one, name: Blip.Metric.Supervisor},
      {Blip.Backend, []}
    ]

    opts = [strategy: :one_for_one, name: Blip.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp sockets do
    Application.get_env(:blip, :port)
    |> List.wrap
    |> Enum.map(&Supervisor.child_spec({Blip.UDPServer, &1}, id: &1))
  end
end
