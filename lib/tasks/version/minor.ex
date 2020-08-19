defmodule Mix.Tasks.Version.Minor do
  use Mix.Task

  require Logger

  alias VersionRelease.Changelog
  alias VersionRelease.Config
  alias VersionRelease.Git
  alias VersionRelease.Version

  def run(opts) do
    opts
    |> Config.create()
    |> Git.is_clean()
    |> bump_minor()
    |> Changelog.update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Version.next_dev_iteration()
    |> Git.push()
  end

  defp bump_minor(
         %{
           current_version:
             %{
               minor: minor,
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
      |> Map.put(:minor, minor + 1)
      |> Map.put(:patch, 0)
      |> Map.delete(:pre_release)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end

  defp bump_minor(
         %{
           current_version:
             %{
               minor: minor
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
      |> Map.put(:minor, minor + 1)
      |> Map.put(:patch, 0)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end
end
