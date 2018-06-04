defmodule StatsD.MixProject do
  use Mix.Project

  def project do
    [
      app: :statsd,
      version: "0.1.0",
      elixir: "~> 1.6",
      escript: escript(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 0.3.0"}
    ]
  end

  defp escript do
    [main_module: StatsD.CLI]
  end
end
