defmodule Mix.Tasks.Version.Beta do
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
    |> Git.clean?()
    |> Git.current_tag(:beta)
    |> bump_beta()
    |> Changelog.pre_release_update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Git.merge()
    |> Git.push()
  end

  defp bump_beta(
         %{
           current_git_tag: %{
             pre_release: %{
               extension: "beta",
               version: beta_version
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
        extension: "beta",
        version: beta_version + 1
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-beta.#{pre_ver}"
    )

    params |> Map.put(:new_version, new_version)
  end

  defp bump_beta(
         %{
           current_version:
             %{
               pre_release: %{
                 extension: "beta",
                 version: beta_version
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
        extension: "beta",
        version: beta_version + 1
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-beta.#{pre_ver}"
    )

    params |> Map.put(:new_version, new_version)
  end

  defp bump_beta(
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
        extension: "beta",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-beta.#{pre_ver}"
    )

    params |> Map.put(:new_version, new_version)
  end

  defp bump_beta(
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
        extension: "beta",
        version: 0
      })

    Logger.info(
      "Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}-beta.#{pre_ver}"
    )

    params |> Map.put(:new_version, new_version)
  end
end
