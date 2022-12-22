defmodule VersionRelease.VersionTest do
  use ExUnit.Case, async: true

  describe "parse/1" do
    test "1.0.0" do
      assert %{major: 1, minor: 0, patch: 0} = VersionRelease.Version.parse("1.0.0")
    end

    test "1.0.0-alpha.1" do
      assert %{
        major: 1, minor: 0, patch: 0,
        pre_release: %{extension: "alpha", version: 1}
      } = VersionRelease.Version.parse("1.0.0-alpha.1")
    end
  end
end
