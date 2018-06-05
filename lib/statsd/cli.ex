defmodule StatsD.CLI do
  def main(args \\ []) do
    args |> parse |> start
  end

  defp parse(args) do
    OptionParser.parse(args)
  end

  defp start(options = {[version: true], _, _}) do
    {:ok, vsn} = :application.get_key(:statsd, :vsn)

    IO.puts("v#{vsn}")
  end

  defp start(options = {[help: true], _, _}) do
    IO.puts """
    USAGE: statsd <portA> <portB> ... <portN> [options]

    Default port is 2052

    OPTIONS

      --help
      --version
      --flush default is `1000`
      --backend default is `console`
    """
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
