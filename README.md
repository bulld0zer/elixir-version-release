# Version release for elixir
![GitHub release (latest by date)](https://img.shields.io/github/v/release/bulld0zer/elixir-version-release)
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

Current release: 0.0.1-beta.16

Add to mix.exs
```
def deps do
  [
    ...other
    {:version_release, "0.0.1-beta.16", only: :dev, runtime: false}
    ...other
  ]
end
```

## Usage

`mix version.[level] [--dry-run | -dr] [--no-git-push | -np]`

| level | description                                                            |
|-------|------------------------------------------------------------------------|
| major | Creates major realease version.       I.e. from 1.2.3 to 2.2.3         |
| minor | Creates minor realease version.       I.e. from 1.2.3 to 1.3.3         |
| patch | Creates patch realease version.       I.e. from 1.2.3 to 1.2.4         |
| rc    | Creates realease candidate version.   I.e. from 1.2.3 to 1.2.4-rc.0    |
| beta  | Creates beta realease version.        I.e. from 1.2.3 to 1.2.4-beta.0  |
| alpha | Creates alpha realease version.       I.e. from 1.2.3 to 1.2.4-alpha.0 |


## Settings
| Name        | Type    | Description |
|-------------|---------|-------------|
| tag_prefix  | String  | Tag prefix usually just `v` (short for version). Will be created from version. I.e. if version is 1.2.3 and tag prefix is "ver" resulting tag will be `ver1.2.3`
| hex_publish | Boolean | Disabled by default. Enable publishing to hex.pm Should authorize beforehand. Check [Publishing a package](https://hex.pm/docs/publish) article. 
| git_push    | Boolean | Enabled by default. Enable git push at the endof all operations
| changelog   | Config  | Configuration for changelog. Check [Changelog](#changelog) section
| merge       | Config  | Configuration for mergeing. Check [Merging](#merging) section

### Prerequisite

* Your project should be managed by git.

## Changelog

[Why keep a changelog and how](https://keepachangelog.com/en/1.0.0/)

### Settings
| Name          | Type      | Description                   |
|---------------|-----------|-------------------------------|
| creation      | Atom      | Mode of creation.             |
| replacements  | Config[]  | List of replacement settings  |

#### Creation settings
| Option        | Description                   |
|---------------|-------------------------------|
| disabled      | Changelog will not be created |
| manual        | Changelog will updated accordingly to replacements settings. Replacement values are `{{version}}`, `{{date}}`, `{{tag_name}}`. Everything that actually has changed should be written directly to changelog file
| git_logs      | !Not implemented! Same as manual, but additionally if git commit massage starts with `add! `, `change! `, `fix! `, message will be added to changelog.

#### Replacements settings
| Name      | Type      | Description                             |
|-----------|-----------|-----------------------------------------|
| file      | String    | File name in which to do replacements.  |
| patterns  | Config[]  | List of pattern settings                |

#### Patterns settings
| Name      | Type          | Description                             |
|-----------|---------------|-----------------------------------------|
| search    | String/RegEx  | Pattern to serch in specified file      |
| replace   | String        | String which will replace what is found. (`{{version}}`, `{{date}}`, `{{tag_name}}` Will be replaced accordingly)  |
| global    | Boolean       | File name in which to do replacements.  |

### Examples
Check this repo [config](/config/config.exs) or [elixir-version-release-tests](https://github.com/bulld0zer/elixir-version-release-tests/) repo [config](https://github.com/bulld0zer/elixir-version-release-tests/blob/master/config/config.exs) to have some examples how to configure chanelog updates.

## Merging (Not implemented)
Sometimes it is useful to keep 2 or more branches up to date with the branch that you are doing version bump from

## License
Licensed under [MIT license](LICENSE)

## PS
If you found this library useful, dont forget to star it (on github) =)

![GitHub stars](https://img.shields.io/github/stars/bulld0zer/elixir-version-release?style=social)