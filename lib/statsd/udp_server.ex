defmodule StatsD.UDPServer do
  use GenServer, restart: :permanent

  def start_link(port) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    :gen_udp.open(port, [:binary, active: true])
  end

  def handle_info({:udp, socket, _address, _port, data}, socket) do
    StatsD.record_text(data)

    {:noreply, socket}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
