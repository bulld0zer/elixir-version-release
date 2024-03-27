defmodule VersionRelease.Git.SystemBehaviour do
  @callback cmd(binary(), [binary()], keyword()) :: {Collectable.t(), exit_status :: non_neg_integer}
end
