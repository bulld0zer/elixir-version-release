defmodule Mix.Tasks.Version do
  use Mix.Task

  def run(_opts) do
    VersionRelease.Config.print_help()
  end
end
