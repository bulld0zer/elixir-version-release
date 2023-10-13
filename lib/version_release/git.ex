defmodule VersionRelease.Git do
  require Logger

  alias VersionRelease.Config
  alias VersionRelease.Version
  alias __MODULE__

  def push(%{dry_run: false, error: false, git_push: true} = config) do
    Logger.info("Push to github with tags")
    # System.cmd("git", ["push"])
    Git.Cli.push([])
    # System.cmd("git", ["push", "--tags"])
    Git.Cli.push(["--tags"])

    config
  end

  def push(%{dry_run: true, error: false, git_push: true} = config) do
    Logger.info("Push to github with tags")
    config
  end

  def push(config) do
    config
  end

  defp current_branch() do
    # System.cmd("git", ["branch", "--show-current"])
    Git.Cli.branch(["--show-current"])
    |> elem(0)
    |> String.trim("\r\n")
    |> String.trim("\n")
  end

  def is_clean(config) do
    # System.cmd("git", ["diff", "HEAD", "--exit-code", "--name-only"])
    # prev_tag = :os.cmd(:"git tag --sort version:refname | tail -n 1 | tr -d '\\n'")
    # System.cmd("git", ["describe", "--tags", "--abbrev=0"])
    prev_tag =
      Git.Cli.describe(["--tags", "--abbrev=0"])
      |> Git.Cli.get_elem(0)
      |> case do
        "" -> Git.Cli.rev_list(["--max-parents=0", "HEAD"]) |> Git.Cli.get_elem(0)
        pt -> pt
      end

    # System.cmd("git", ["diff", "--compact-summary", "#{prev_tag}"])
    Git.Cli.diff(["--compact-summary", prev_tag])
    |> case do
      {"", 0} ->
        ask_to_proceed()

      {" mix.exs | 2 +-\n 1 file changed, 1 insertion(+), 1 deletion(-)\n", 0} ->
        ask_to_proceed()

      _ ->
        nil
    end

    # System.cmd("git", ["status", "--porcelain"])
    Git.Cli.status(["--porcelain"])
    |> case do
      {"", 0} ->
        config

      {res, 0} ->
        Logger.error("Uncommitted changes detected, please commit before release. \n#{res}")
        System.stop(1)
        Map.put(config, :error, true)

      res ->
        Logger.error("Something wrong with working directory. \n #{inspect(res)}")
        System.stop(1)
        Map.put(config, :error, true)
    end
  end

  def is_able_to_merge(
        %{
          error: false,
          merge:
            %{
              ignore_configs: ignore_conflicts
            } = merge
        } = config
      ) do
    Logger.warn(
      "ignore_configs was deprecated and will be removed. PLease change it in config to ignore_conflicts"
    )

    config
    |> Map.put(
      :merge,
      merge
      |> Map.put(:ignore_conflicts, ignore_conflicts)
      |> Map.delete(:ignore_configs)
    )
    |> is_able_to_merge()
  end

  def is_able_to_merge(
        %{
          error: false,
          merge: %{
            ignore_conflicts: ignore_conflicts,
            branches: branches
          }
        } = config
      )
      when is_list(branches) do
    Logger.info("Checking if it will be possible to merge")

    Enum.reduce(branches, true, fn %{from: from, to: tos}, acc ->
      if current_branch() == from do
        Enum.reduce(tos, acc, fn to, acc2 ->
          check_is_able_to_merge(from, to)
          |> case do
            {:ok, _} -> acc2
            {:error, _} -> false
          end
        end)
      else
        acc
      end
    end)
    |> case do
      true ->
        config

      _ ->
        Logger.error("Merge operation will fail. Please fix merge conflicts manually")

        if ignore_conflicts != true do
          System.stop(1)
          Map.put(config, :error, true)
        else
          config
        end
    end
  end

  def is_able_to_merge(config) do
    config
  end

  defp check_is_able_to_merge(from, to) do
    # System.cmd("git", ["checkout", to, "--quiet"])
    Git.Cli.checkout([to, "--quiet"])

    # System.cmd("git", ["merge", "--no-commit", "--no-ff", from, "--quiet"])
    res =
      Git.Cli.merge(["--no-commit", "--no-ff", from, "--quiet"])
      |> case do
        {_, 0} ->
          Logger.info("#{from} -> #{to}: ok")
          {:ok, "#{from} -> #{to}"}

        {error, 1} ->
          Logger.warn("#{from} -> #{to}: fault \n #{error}")
          {:error, error}
      end

    # System.cmd("git", ["merge", "--abort"])
    Git.Cli.merge(["abort"])
    # System.cmd("git", ["checkout", from, "--quiet"])
    Git.Cli.checkout([from, "--quiet"])

    res
  end

  def current_tag(
        %{tag_prefix: tag_prefix, current_version: %{major: major, minor: minor, patch: patch}} =
          config,
        cycle
      ) do
    # System.cmd("git", [
    #   "tag",
    #   "-l",
    #   "--sort",
    #   "version:refname",
    #   "#{tag_prefix}#{major}.#{minor}.#{patch}-#{cycle}.*"
    # ])
    Git.Cli.tag([
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

  def tag_with_new_version(%{dry_run: false, error: false} = config) do
    tag = Config.get_new_tag_str(config)
    Logger.info("Tag with #{tag}")
    System.cmd("git", ["tag", tag])
    config
  end

  def tag_with_new_version(%{dry_run: true, error: false} = config) do
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

  def merge(
        %{
          error: false,
          merge: %{branches: branches}
        } = config
      )
      when is_list(branches) do
    Logger.info("Merging changes")

    merge_from_cycle(branches, config, current_branch())

    config
  end

  def merge(config) do
    config
  end

  defp merge_from_cycle([merge | tail], config, current_branch) do
    merge_to_cycle(merge, config, current_branch)
    merge_from_cycle(tail, config, current_branch)
  end

  defp merge_from_cycle(_, _, _) do
  end

  defp merge_to_cycle(%{from: from, to: [to | tail]} = merge, config, current_branch)
       when from == current_branch do
    merge_to_cycle(%{from: from, to: tail}, config, current_branch)

    %{
      from: from,
      to: to,
      strategy: Map.get(merge, :strategy, []),
      message: Map.get(merge, :message)
    }
    |> do_merge(config)
  end

  defp merge_to_cycle(%{from: _from, to: _}, _dry_run, _current_branch) do
  end

  defp do_merge(%{from: from, to: to, strategy: strategy} = params, %{dry_run: false} = config) do
    Logger.info("Merging from #{from} to #{to}")
    # System.cmd("git", ["checkout", to, "--quiet"])
    Git.Cli.checkout([to, "--quiet"])

    # System.cmd("git", ["merge"] ++ wrap_strategy(strategy) ++ [from, "--quiet"])
    Git.Cli.merge(maybe_add_message(params) ++ wrap_strategy(strategy) ++ [from, "--quiet"])
    |> case do
      {_, 0} ->
        push(config)

      {error, 1} ->
        Logger.warn("Merge from #{from} to #{to} aborted \n #{error}")
        # System.cmd("git", ["merge", "--abort"])
        Git.Cli.merge(["--abort"])
    end

    # System.cmd("git", ["checkout", from, "--quiet"])
    Git.Cli.checkout([from, "--quiet"])
  end

  defp do_merge(%{from: from, to: to, strategy: strategy}, %{dry_run: true}) do
    Logger.info("Merging from #{from} to #{to}")
    # System.cmd("git", ["checkout", to, "--quiet"])
    Git.Cli.checkout([to, "--quiet"])

    # System.cmd(
    #   "git",
    #   ["merge", "--no-commit", "--no-ff"] ++ wrap_strategy(strategy) ++ [from, "--quiet"]
    # )
    Git.Cli.merge(["--no-commit", "--no-ff"] ++ wrap_strategy(strategy) ++ [from, "--quiet"])
    |> case do
      {_, 0} -> nil
      {error, 1} -> Logger.error(error)
    end

    # System.cmd("git", ["merge", "--abort"])
    Git.Cli.merge(["--abort"])
    # System.cmd("git", ["checkout", from, "--quiet"])
    Git.Cli.checkout([from, "--quiet"])
  end

  defp wrap_strategy([]) do
    []
  end

  defp wrap_strategy(strategy) do
    ["-s"] ++ List.wrap(strategy)
  end

  defp maybe_add_message(%{from: from, to: to, message: message}) when message |> is_binary do
    message =
      message
      |> String.replace("{{from}}", from)
      |> String.replace("{{to}}", to)

    ["--no-ff", "-m", message]
  end

  defp maybe_add_message(_) do
    []
  end
end
