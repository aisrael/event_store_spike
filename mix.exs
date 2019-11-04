defmodule Hello.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Hello.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:extreme, "~> 0.13.2"},
      {:msgpax, "~> 2.0"}
    ]
  end
end
