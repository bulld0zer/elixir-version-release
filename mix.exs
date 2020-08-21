defmodule VersionRelease.MixProject do
  use Mix.Project

  def project do
    [
      app: :version_release,
      version: "0.0.1-beta.4",
      elixir: "~> 1.8",
      description: "Project version and changelog managment for elixir. Insparation for functionality is taken from [cargo-release](https://github.com/sunng87/cargo-release) package for Rust",
      package: [
        name: "version_release",
        files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/bulld0zer/elixir-version-release"}
      ],
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
