defmodule VersionRelease.Git.Cli do
  @system Application.compile_env(:version_release, :system, System)

  defp cmd(args) when is_list(args) do
    @system.cmd("git", args, [])
  end

  def get_elem(res, el) do
    res
    |> elem(el)
    |> case do
      el when is_binary(el) ->
        el
        |> String.trim("\r\n")
        |> String.trim("\n")

      el ->
        el
    end
  end

  def push(options) when is_list(options) do
    cmd(["push"] ++ options)
  end

  def branch(options) when is_list(options) do
    cmd(["branch"] ++ options)
  end

  def describe(options) when is_list(options) do
    cmd(["describe"] ++ options)
  end

  def status(options) when is_list(options) do
    cmd(["status"] ++ options)
  end

  def diff(options) when is_list(options) do
    cmd(["diff"] ++ options)
  end

  def checkout(options) when is_list(options) do
    cmd(["checkout"] ++ options)
  end

  def merge(options) when is_list(options) do
    cmd(["merge"] ++ options)
  end

  def tag(options) when is_list(options) do
    cmd(["tag"] ++ options)
  end

  def log(options) when is_list(options) do
    cmd(["log"] ++ options)
  end

  def rev_list(options) when is_list(options) do
    cmd(["rev-list"] ++ options)
  end
end
