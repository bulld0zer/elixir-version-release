defmodule Mix.Tasks.Version.Next do
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
    |> Changelog.get_release_changes()
    |> Git.clean?()
    |> bump_version()
    |> Changelog.update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Version.next_dev_iteration()
    |> Git.merge()
    |> Git.push()
  end

  defp bump_version(
         %{
           changelog: %{
             changes: %{
               major: major_changes,
               minor: minor_changes,
               patch: patch_changes
             }
           }
         } = config
       ) do
    %{
      major_count: major_changes |> Enum.count(),
      minor_count: minor_changes |> Enum.count(),
      patch_count: patch_changes |> Enum.count()
    }
    |> case do
      %{major_count: count} when count > 0 ->
        Mix.Tasks.Version.Major.bump_major(config)

      %{minor_count: count} when count > 0 ->
        Mix.Tasks.Version.Minor.bump_minor(config)

      _ ->
        Mix.Tasks.Version.Patch.bump_patch(config)
    end
  end
end
