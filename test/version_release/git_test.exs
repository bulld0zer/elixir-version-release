defmodule VersionRelease.GitTest do
  use ExUnit.Case

  import Mox
  import ExUnit.CaptureLog

  alias VersionRelease.Git
  alias VersionRelease.Test.Stubs.Config

  setup :verify_on_exit!

  describe "push/1" do
    test "with default config" do
      SystemMock
      |> expect(:cmd, fn "git", ["push"], [] -> {"", 0} end)
      |> expect(:cmd, fn "git", ["push", "--tags"], [] -> {"", 0} end)

      config = Config.create()

      log = capture_log fn ->
        assert config == config |> Git.push()
      end

      assert log =~ "Push to github with tags\n"
    end

    test "with dry run" do
      config = Config.create(%{dry_run: true})

      log = capture_log fn ->
        assert config == config |> Git.push()
      end

      assert log =~ "Push to github with tags\n"
    end

    test "without git push" do
      config = Config.create(%{git_push: false})
      assert config == config |> Git.push()
    end

    test "with error" do
      config = Config.create(%{error: true})
      assert config == config |> Git.push()
    end

    test "with git error" do
      SystemMock
      |> expect(:cmd, fn "git", ["push"], [] -> {"", 1} end)
      |> expect(:cmd, fn "git", ["push", "--tags"], [] -> {"", 1} end)

      assert %{error: true} = Config.create() |> Git.push() |> IO.inspect()
    end
  end
end
