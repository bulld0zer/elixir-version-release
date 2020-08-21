defmodule Mix.Tasks.Version.Rc do
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
    |> bump_rc()
    |> Changelog.update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Git.push()
  end

  defp bump_rc(
         %{
           current_version:
             %{
               pre_release: %{
                 extension: "rc",
                 version: rc_version
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
        extension: "rc",
        version: rc_version + 1
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-rc.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end

  defp bump_rc(
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
        extension: "rc",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-rc.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end

  defp bump_rc(
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
        extension: "rc",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-rc.#{
        pre_ver
      }"
    )

    params |> Map.put(:new_version, new_version)
  end
end
