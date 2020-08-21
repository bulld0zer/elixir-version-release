defmodule VersionRelease.Hex do
  require Logger

  def publish(%{dry_run: false, wd_clean: true} = config) do
    Logger.info("Publish on Hex.pm")
    System.cmd("mix", ["hex.publish"])

    config
  end

  def publish(%{dry_run: true, wd_clean: true} = config) do
    Logger.info("Publish on Hex.pm")
    config
  end

  def publish(config) do
    config
  end
end