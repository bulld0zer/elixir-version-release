defmodule VersionRelease.MixProject do
  use Mix.Project

  def project do
    [
      app: :version_release,
      version: "0.0.1-alpha.0",
      elixir: "~> 1.8",
      elixirc_paths: ["lib"],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
