defmodule Mix.Tasks.Version.Patch do
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
    |> bump_patch()
    |> Changelog.update()
    |> Version.update_mix_file()
    |> Git.tag_with_new_version()
    |> Hex.publish()
    |> Version.next_dev_iteration()
    |> Git.merge()
    |> Git.push()
  end

  def bump_patch(
        %{
          current_version:
            %{
              patch: _patch,
              pre_release: _
            } = current_version
        } = params
      ) do
    new_version =
      %{
        major: major,
        minor: minor,
        patch: patch
      } = current_version |> Map.delete(:pre_release)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end

  def bump_patch(
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
        patch: patch
      } = current_version |> Map.put(:patch, patch + 1)

    Logger.info("Next version of #{Mix.Project.config()[:app]} will be #{major}.#{minor}.#{patch}")

    params |> Map.put(:new_version, new_version)
  end
end
