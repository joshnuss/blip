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

  defp set_port([port]) do
    Application.put_env(:statsd, :port, String.to_integer(port))
  end

  defp set_port(_), do: nil
end
