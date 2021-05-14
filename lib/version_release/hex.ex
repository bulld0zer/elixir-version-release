defmodule VersionRelease.Hex do
  require Logger

  def publish(%{dry_run: false, error: false, hex_publish: true} = config) do
    Logger.info("Publish on Hex.pm")
    Mix.Task.run("hex.publish")

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
