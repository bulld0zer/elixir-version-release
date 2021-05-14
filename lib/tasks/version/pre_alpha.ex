defmodule Mix.Tasks.Version.Alpha do
  use Mix.Task

  require Logger

  alias VersionRelease.Changelog
  alias VersionRelease.Config
  alias VersionRelease.Git
  alias VersionRelease.Hex
  alias VersionRelease.Version

  def run(opts) do
    opts
    |> Config.create()
    |> Git.is_clean()
    |> Git.is_mergable()
    |> Git.current_tag(:alpha)
    |> bump_alpha()
    |> Changelog.pre_release_update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Git.merge()
    |> Git.push()
  end

  def bump_alpha(
        %{
          current_git_tag: %{
            pre_release: %{
              extension: "alpha",
              version: alpha_version
            }
          },
          current_version: current_version
        } = params
      ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch,
        pre_release: %{
          version: pre_ver
        }
      } =
      current_version
      |> Map.put(:pre_release, %{
        extension: "alpha",
        version: alpha_version + 1
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-alpha.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end

  def bump_alpha(
        %{
          current_version:
            %{
              pre_release: %{
                extension: "alpha",
                version: alpha_version
              }
            } = current_version
        } = params
      ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch,
        pre_release: %{
          version: pre_ver
        }
      } =
      current_version
      |> Map.put(:pre_release, %{
        extension: "alpha",
        version: alpha_version + 1
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-alpha.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end

  def bump_alpha(
        %{
          current_version:
            %{
              pre_release: %{
                extension: _,
                version: _
              }
            } = current_version
        } = params
      ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch,
        pre_release: %{
          version: pre_ver
        }
      } =
      current_version
      |> Map.put(:pre_release, %{
        extension: "alpha",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-alpha.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end

  def bump_alpha(
        %{
          current_version:
            %{
              patch: patch
            } = current_version
        } = params
      ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch,
        pre_release: %{
          version: pre_ver
        }
      } =
      current_version
      |> Map.put(:patch, patch + 1)
      |> Map.put(:pre_release, %{
        extension: "alpha",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-alpha.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end
end
