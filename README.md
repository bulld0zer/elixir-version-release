# Version release for elixir
<!-- ![GitHub release (latest by date)](https://img.shields.io/github/v/release/bulld0zer/elixir-version-release) -->
![Hex.pm](https://img.shields.io/hexpm/v/version_release)
![Hex.pm](https://img.shields.io/hexpm/dt/version_release)
[![Docs](https://img.shields.io/badge/hex-docs-blue)](https://hexdocs.pm/version_release)

  Project version and changelog managment for elixir. Insparation for functionality is taken from [cargo-release](https://github.com/sunng87/cargo-release) package for Rust

  Performs release best-practices, including:

  * Ensure the git working directory is clean.
  * Bump the version in mix.exs
  * Create a git tag for this version
  * Run mix release (disabled by default)
  * Bump version for next development cycle
  * Push everything to github

## Install
Current release: 0.2.0

Add to mix.exs
```elixir
def deps do
  [
    ...other
    {:version_release, "0.2.0", only: :dev, runtime: false}
    ...other
  ]
end
```

## Usage
`mix version.[level] [--dry-run | -d] [--skip-push | -g] [--skip-publish | -h] [--skip-dev-version | -v] [--skip-merge | -m] [--tag-prefix=<tag_prefix>]`

Check [reference](/docs/REFERENCE.md) for more info on levels, other configuration options and CLI commands
Or type `mix version` for quick help.

### Prerequisite
* Your project should be managed by git.

## Changelog
[Why keep a changelog and how](https://keepachangelog.com/en/1.0.0/)

### Examples
Check this repo [config](/config/config.exs) or [elixir-version-release-tests](https://github.com/bulld0zer/elixir-version-release-tests/) repo [config](https://github.com/bulld0zer/elixir-version-release-tests/blob/master/config/config.exs) to have some examples how to configure chanelog updates.

## Merging
Sometimes it is useful to keep 2 or more branches up to date with the branch that you are doing version bump from.
See [reference merging section](/docs/REFERENCE.md#merge) for more info.

## License
Licensed under [MIT license](LICENSE)

## PS
If you found this library useful, dont forget to star it (on github) =)

![GitHub stars](https://img.shields.io/github/stars/bulld0zer/elixir-version-release?style=social)