defmodule VersionRelease.Version do
  require Logger

  alias VersionRelease.Config

  def update_mix_file(%{dry_run: false, wd_clean: true, commit_message: commit_message} = config) do
    version = Config.get_new_version_str(config)
    update_mix_version(version)
    commit_message = String.replace(commit_message, "{{version}}", version)
    System.cmd("git", ["commit", "-am", commit_message])

    config
  end

  def update_mix_file(%{dry_run: true, wd_clean: true} = config) do
    file_name = "mix.exs"
    version = Config.get_new_version_str(config)
    Logger.info("Update #{file_name} version #{version}")
    config
  end

  def update_mix_file(config) do
    config
  end

  def next_dev_iteration(
        %{dry_run: false, wd_clean: true, dev_version: true, new_version: new_version} = config
      ) do
    next_iteration_version =
      %{current_version: new_version}
      |> Mix.Tasks.Version.Alpha.bump_alpha()
      |> Config.get_new_version_str()

    update_mix_version(next_iteration_version)

    System.cmd("git", [
      "commit",
      "-am",
      "[version_release] start next development iteration #{next_iteration_version}"
    ])

    Logger.info("Start next development iteration #{next_iteration_version}")
    config
  end

  def next_dev_iteration(
        %{dry_run: true, wd_clean: true, dev_version: true, new_version: new_version} = config
      ) do
    next_iteration_version =
      %{current_version: new_version}
      |> Mix.Tasks.Version.Alpha.bump_alpha()
      |> Config.get_new_version_str()

    Logger.info("Start next development iteration #{next_iteration_version}")
    config
  end

  def next_dev_iteration(config) do
    config
  end

  def parse(version) when is_binary(version) do
    version
    |> String.split(".")
    |> case do
      [major, minor, patch] ->
        %{
          major: major |> Integer.parse() |> elem(0),
          minor: minor |> Integer.parse() |> elem(0),
          patch: patch |> Integer.parse() |> elem(0)
        }

      [major, minor, patch_and_ext, pre] ->
        [patch, ext] = patch_and_ext |> String.split("-")

        %{
          major: major |> Integer.parse() |> elem(0),
          minor: minor |> Integer.parse() |> elem(0),
          patch: patch |> Integer.parse() |> elem(0),
          pre_release: %{
            version: pre |> Integer.parse() |> elem(0),
            extension: ext
          }
        }
    end
  end

  defp update_mix_version(version) do
    file_name = "mix.exs"
    Logger.info("Update #{file_name} version #{version}")

    file_name
    |> File.read()
    |> case do
      {:ok, body} ->
        replaced =
          String.replace(body, ~r/version: \"(.*)\"/, "version: \"#{version}\"", global: false)

        {:ok, file_pid} = File.open(file_name, [:write])
        IO.write(file_pid, replaced)
        File.close(file_pid)
        update_version(version)

      err ->
        Logger.error(err)
    end
  end

  defp update_version(new_version) do
    GenServer.call(
      Mix.ProjectStack,
      {:update_stack,
       fn [%{config: config}] = stack ->
         config = Keyword.put(config, :version, new_version)
         {:ok, [%{hd(stack) | config: config}]}
       end}
    )
  end
end
