defmodule Eight.MixProject do
  use Mix.Project

  def project do
    [
      app: :eight,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [main_module: Eight.CLI]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"}
    ]
  end
end
