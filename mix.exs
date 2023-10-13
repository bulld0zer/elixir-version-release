defmodule VersionRelease.MixProject do
  use Mix.Project

  def project do
    [
      app: :version_release,
      version: "0.5.3",
      elixir: "~> 1.8",
      description: "Project version and changelog managment",
      package: [
        name: "version_release",
        files: ~w(lib .formatter.exs mix.exs README* LICENSE CHANGELOG*),
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/bulld0zer/elixir-version-release"}
      ],
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md", "LICENSE", "docs/REFERENCE.md"]
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
