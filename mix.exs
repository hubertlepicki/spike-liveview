defmodule Spike.LiveView.MixProject do
  use Mix.Project

  @description "spike_liveview helps you build stateul forms / UIs with Phoenix LiveView"

  def project do
    [
      app: :spike_liveview,
      description: @description,
      version: "0.4.0-rc.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/hubertlepicki/spike-liveview",
      homepage_url: "https://github.com/hubertlepicki/spike-liveview",
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        logo: "assets/spike-logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/hubertlepicki/spike-liveview"
      },
      files: ~w(lib mix.exs mix.lock README.md LICENSE)
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
      {:spike, "~> 0.4.0-rc.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end
end
