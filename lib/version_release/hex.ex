defmodule VersionRelease.Hex do
  require Logger

  def publish(%{dry_run: false, error: false, hex_publish: true} = config) do
    Logger.info("Publish on Hex.pm")

    Map.get(config, :hex_publish_force, false)
    |> case do
      true ->
        Mix.Task.run("hex.publish --yes")

      _ ->
        Mix.Task.run("hex.publish")
    end

    config
  end

  def publish(%{dry_run: true, error: false, hex_publish: true} = config) do
    Logger.info("Publish on Hex.pm")
    config
  end

  def publish(config) do
    config
  end
end
