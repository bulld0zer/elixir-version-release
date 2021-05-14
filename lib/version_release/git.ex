defmodule VersionRelease.Git do
  require Logger

  alias VersionRelease.Config
  alias VersionRelease.Version

  def push(%{dry_run: false, wd_clean: true, git_push: true} = config) do
    Logger.info("Push to github with tags")
    System.cmd("git", ["push"])
    System.cmd("git", ["push", "--tags"])

    config
  end

  def push(%{dry_run: true, wd_clean: true, git_push: true} = config) do
    Logger.info("Push to github with tags")
    config
  end

  def push(config) do
    config
  end

  def is_clean(config) do
    # System.cmd("git", ["diff", "HEAD", "--exit-code", "--name-only"])
    prev_tag = :os.cmd(:"git tag --sort version:refname | tail -n 1 | tr -d '\\n'")

    System.cmd("git", ["diff", "--compact-summary", "#{prev_tag}"])
    |> case do
      {"", 0} ->
        ask_to_proceed()

      {" mix.exs | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n", 0} ->
        ask_to_proceed()

      _ ->
        nil
    end

    System.cmd("git", ["status", "--porcelain"])
    |> case do
      {"", 0} ->
        Map.put(config, :wd_clean, true)

      {res, 0} ->
        Logger.warn("Uncommitted changes detected, please commit before release. \n#{res}")
        Map.put(config, :wd_clean, false)

      res ->
        Logger.warn("Something wrong with working directory. \n #{inspect(res)}")
        Map.put(config, :wd_clean, false)
    end
  end

  def current_tag(
        %{tag_prefix: tag_prefix, current_version: %{major: major, minor: minor, patch: patch}} =
          config,
        cycle
      ) do
    System.cmd("git", [
      "tag",
      "-l",
      "--sort",
      "version:refname",
      "#{tag_prefix}#{major}.#{minor}.#{patch}-#{cycle}.*"
    ])
    |> case do
      {"", 0} ->
        config

      {versions, 0} ->
        last_version =
          versions
          |> String.split("\n")
          |> Enum.reject(fn val -> val == "" end)
          |> Enum.at(-1)
          |> String.replace_prefix(tag_prefix, "")

        Map.put(config, :current_git_tag, Version.parse(last_version))

      _res ->
        config
    end
  end

  def tag_with_new_version(%{dry_run: false, wd_clean: true} = config) do
    tag = Config.get_new_tag_str(config)
    Logger.info("Tag with #{tag}")
    System.cmd("git", ["tag", tag])
    config
  end

  def tag_with_new_version(%{dry_run: true, wd_clean: true} = config) do
    tag = Config.get_new_tag_str(config)
    Logger.info("Tag with #{tag}")
    config
  end

  def tag_with_new_version(config) do
    config
  end

  def ask_to_proceed() do
    IO.puts("No changes since last release")
    IO.puts("Proceed? (y/n)")

    case IO.read(:stdio, 1) do
      "n" -> System.halt(0)
      _ -> nil
    end
  end

  def merge(%{dry_run: dry_run, wd_clean: true, merge: merge} = config) when is_list(merge) do
    Logger.info("Merging changes")

    current_branch =
      "git"
      |> System.cmd(["branch", "--show-current"])
      |> elem(0)
      |> String.trim("\r\n")
      |> String.trim("\n")

    merge_from_cycle(merge, dry_run, current_branch)

    config
  end

  def merge(config) do
    config
  end

  defp merge_from_cycle([merge | tail], dry_run, current_branch) do
    merge_to_cycle(merge, dry_run, current_branch)
    merge_from_cycle(tail, dry_run, current_branch)
  end

  defp merge_from_cycle(_, _, _) do
  end

  defp merge_to_cycle(%{from: from, to: [to | tail]}, dry_run, current_branch)
       when from == current_branch do
    merge_to_cycle(%{from: from, to: tail}, dry_run, current_branch)
    do_merge(%{from: from, to: to}, dry_run)
  end

  defp merge_to_cycle(%{from: _from, to: _}, _dry_run, _current_branch) do
  end

  defp do_merge(%{from: from, to: to}, false) do
    Logger.info("Merging from #{from} to #{to}")
    System.cmd("git", ["checkout", to])
    System.cmd("git", ["merge", from])
    System.cmd("git", ["checkout", from])
  end

  defp do_merge(%{from: from, to: to}, true) do
    Logger.info("Merging from #{from} to #{to}")
  end
end
