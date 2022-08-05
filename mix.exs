defmodule Spike.LiveView.MixProject do
  use Mix.Project

  def project do
    [
      app: :spike_liveview,
      version: "0.1.0",
      elixir: "~> 1.13",
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
      {:spike, github: "hubertlepicki/spike"},
      {:phoenix_live_view, "~> 0.17"},
    ]
  end
end