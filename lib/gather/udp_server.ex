defmodule Gather.UDPServer do
  use GenServer, restart: :permanent

  def start_link(port \\ 2052) do
    GenServer.start_link(__MODULE__, port)
  end

  def init(port) do
    :gen_udp.open(port, [:binary, active: true])
  end

  def handle_info({:udp, socket, _address, _port, data}, socket) do
    IO.puts("Received: #{String.trim data}")

    {:noreply, socket}
  end
end
