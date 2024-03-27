defmodule Git.CliTest do
  use ExUnit.Case

  import Mox

  alias VersionRelease.Git

  setup :verify_on_exit!

  describe "get_elem/2" do
    test "returns the element" do
      assert Git.Cli.get_elem({"foo\n", 0}, 0) == "foo"
    end

    test "not a string element" do
      assert Git.Cli.get_elem({"foo\n", 0}, 1) == 0
    end

    test "empty string element" do
      assert Git.Cli.get_elem({"\n", 0}, 0) == ""
    end

    test "out of bounds element" do
      assert_raise ArgumentError, fn ->
        Git.Cli.get_elem({"foo\n", 0}, 3)
      end
    end
  end

  describe "push/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["push", "--tags"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.push(["--tags"])
    end
  end

  describe "branch/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["branch", "--show-current"], [] -> {"foo\n", 0} end)
      assert {"foo\n", 0} == Git.Cli.branch(["--show-current"])
    end
  end

  describe "describe/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["describe", "--tags", "--abbrev=0"], [] -> {"foo\n", 0} end)
      assert {"foo\n", 0} == Git.Cli.describe(["--tags", "--abbrev=0"])
    end
  end

  describe "status/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["status"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.status([])
    end
  end

  describe "diff/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["diff", "--compact-summary", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.diff(["--compact-summary", "foo"])
    end
  end

  describe "checkout/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["checkout", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.checkout(["foo"])
    end
  end

  describe "merge/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["merge", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.merge(["foo"])
    end
  end

  describe "tag/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["tag", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.tag(["foo"])
    end
  end

  describe "log/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["log", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.log(["foo"])
    end
  end

  describe "rev_list/1" do
    test "executes correct system operation" do
      expect(SystemMock, :cmd, fn "git", ["rev-list", "foo"], [] -> {"", 0} end)
      assert {"", 0} == Git.Cli.rev_list(["foo"])
    end
  end
end
