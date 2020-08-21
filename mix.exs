defmodule VersionRelease.MixProject do
  use Mix.Project

  def project do
    [
      app: :version_release,
      version: "0.0.1-beta.9",
      elixir: "~> 1.8",
      description: "Project version and changelog managment",
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
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
