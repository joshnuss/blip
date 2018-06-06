defmodule Blip.CLI do
  def main(args \\ []) do
    args |> parse |> start
  end

  defp parse(args) do
    OptionParser.parse(args)
  end

  defp start({[version: true], _, _}) do
    {:ok, vsn} = :application.get_key(:blip, :vsn)

    IO.puts("v#{vsn}")
  end

  defp start({[help: true], _, _}) do
    IO.puts """
    USAGE: blip <portA> <portB> ... <portN> [options]

    Default port is 2052

    OPTIONS

      --help
      --version
      --flush default is `1000`
      --backend default is `console`
    """
  end

  defp start({_, port, _}) do
    set_port(port)

    Blip.Application.start(nil, nil)

    :timer.sleep(:infinity)
  end

  defp set_port([]), do: nil
  defp set_port(ports) do
    ports = Enum.map(ports, &String.to_integer/1)

    Application.put_env(:blip, :port, ports)
  end
end
