defmodule VersionRelease.ConfigTest do
  use ExUnit.Case, async: true

  alias VersionRelease.Config

  describe "create/1" do
    test "default config" do
      assert %{
      dry_run: false,
      error: false,
      prev_release: %{major: 0, minor: 3, patch: 0},
      current_version: %{
        major: _,
        minor: _,
        patch: _,
        pre_release: %{extension: "alpha", version: 0}
      },
      tag_prefix: "v",
      hex_publish: true,
      force_publish: false,
      git_push: true,
      dev_version: true,
      changelog: %{
        minor_patterns: ["added", "changed"],
        major_patterns: ["breaking"],
        creation: :manual,
        replacements: [
          %{
            file: "README.md",
            patterns: [
              %{
                replace: "Current release: {{version}}",
                search: ~r/Current release: (.*)/
              },
              %{
                replace: "version_release, \"{{version}}\",",
                search: ~r/version_release, \"(.*)\",/
              }
            ]
          },
          %{
            file: "CHANGELOG.md",
            patterns: [
              %{replace: "{{version}}", search: "Unreleased", type: :unreleased},
              %{global: false, replace: "...{{tag_name}}", search: "...HEAD"},
              %{replace: "{{date}}", search: "ReleaseDate"},
              %{
                global: false,
                replace: "<!-- next-header -->\n\n## [Unreleased] - ReleaseDate",
                search: "<!-- next-header -->"
              },
              %{
                global: false,
                replace: "<!-- next-url -->\n[Unreleased]: https://github.com/bulld0zer/elixir-version-release/compare/{{tag_name}}...HEAD",
                search: "<!-- next-url -->"
              }
            ],
            type: :changelog
          }
        ],
        pre_release_replacements: nil,
      },
      merge: _,
      commit_message: _
    } = Config.create([])
    end
  end
end
