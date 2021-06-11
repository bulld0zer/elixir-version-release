defmodule VersionRelease.Git.Cli do
  defp cmd(options) when is_list(options) do
    System.cmd("git", options)
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
end
