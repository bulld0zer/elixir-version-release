defmodule VersionRelease.Git do
  require Logger

  alias VersionRelease.Config

  def push(%{dry_run: false, wd_clean: true} = config) do
    Logger.info("Push to github with tags")
    System.cmd("git", ["push"])
    System.cmd("git", ["push", "--tags"])

    config
  end

  def push(%{dry_run: true, wd_clean: true} = config) do
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
end
