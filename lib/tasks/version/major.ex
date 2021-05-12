defmodule Mix.Tasks.Version.Major do
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
    |> bump_major()
    |> Changelog.update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Version.next_dev_iteration()
    |> Git.merge()
    |> Git.push()
  end

  defp bump_major(
         %{
           current_version:
             %{
               major: major,
               pre_release: _
             } = current_version
         } = params
       ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch
      } =
      current_version
      |> Map.put(:major, major + 1)
      |> Map.put(:minor, 0)
      |> Map.put(:patch, 0)
      |> Map.delete(:pre_release)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end

  defp bump_major(
         %{
           current_version:
             %{
               major: major
             } = current_version
         } = params
       ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch
      } =
      current_version
      |> Map.put(:major, major + 1)
      |> Map.put(:minor, 0)
      |> Map.put(:patch, 0)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end
end
