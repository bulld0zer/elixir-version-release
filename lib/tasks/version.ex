defmodule Mix.Tasks.Version do
  use Mix.Task
  alias VersionRelease.Config

  def run(_opts) do
    current_version =
      []
      |> Config.create()
      |> Config.get_current_tag_str()

    IO.puts("\nCurrent version of #{Mix.Project.config()[:app]} is #{current_version}")

    Config.print_help()
  end
end
