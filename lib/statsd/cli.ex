defmodule StatsD.CLI do
  def main(args \\ []) do
    args |> parse |> start
  end

  defp parse(args) do
    OptionParser.parse(args)
  end

  defp start(options = {_, port, _}) do
    set_port(port)

    StatsD.Application.start(nil, nil)

    :timer.sleep(:infinity)
  end

  defp set_port([]), do: nil
  defp set_port(ports) do
    ports = Enum.map(ports, &String.to_integer/1)

    Application.put_env(:statsd, :port, ports)
  end
end
