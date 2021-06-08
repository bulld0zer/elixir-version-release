# Changelog
## Upcoming
* Ability to add pre version hooks. (Like "mix test" before doing anything)
* Add auto changelog based on commits ("added!, fixed!, changed!")
* Check if working directory is clean for merge branches
<!-- next-header -->

## [Unreleased] - ReleaseDate
### Added
* display current version in help
* --skip-merge to skip mergers to other branches.
* additional aliases to CLI
* return `1` on error to system console on error
* option to add merge strategy to `merge` operation
### Fixed
* release new a version not considering previous git tags, only current project version.
* merge conflict issue with `merge` operation. It is possible to change behaviour of `merge` operation by adding `ignore_configs` to `merge` operation config

## [0.1.0] - 2020-9-7
### Added 
* Commit message overwrite
* Separate changelog config for pre release versions
* Added posibility to switch off Hex.pm publish with --skip-publish
* Added posibility to switch off new dev iteration version bump with --skip-dev-version in shell and dev_version in config
* Possibility to merge all changes to other branches

### Changed
* Use OptionParser to get all parameters from shell
* --no-git-push flag to --skip-push

## [0.0.1-beta.17] - 2020-8-25
* fixed license file in mix file

## [0.0.1-beta.16] - 2020-8-25
* fixed license file in mix file
* fixed first entry in changelog

## [0.0.1-beta.15] - 2020-8-25
* added changelog title, 
* fixed -dr shorthand for dry run

## [0.0.1-beta.14] - 2020-8-25
* Possiblity to disable git push
* Updated readme
* Added readme to hexdocs
* Updated help message

## [0.0.1-beta.13] - 2020-8-25
* Fix readme and readme updates

## [0.0.1-beta.12] - 2020-8-25
* Fix hex publish

## [0.0.1-beta.9] - 2020-8-21
### Fix
- Typo in readme
- Typo in tag_name
### Update
- Update readme
  - Added rc and beta tasks
  - Added changelog section

## [0.0.1-beta.8] - 2020-8-21
- Ability to disable hex publish

## [0.0.1-beta.7] - 2020-8-21
- Added hex docks

## [0.0.1-beta.6] - 2020-8-21

## [0.0.1-beta.5] - 2020-8-21
- Added hex config

## [0.0.1-beta.4] - 2020-8-21
- Actially use hex option

## [0.0.1-beta.3] - 2020-8-21
### Added
- Publish tto hex option

## [0.0.1-beta.2] - 2020-8-19
- Fixed readme update

## [0.0.1-beta.1] - 2020-8-19
- Fix changelog
- Fix changelog config
- Added readme update

## [0.0.1] - 2020-8-19
- Main logic

<!-- next-url -->
[Unreleased]: https://github.com/bulld0zer/elixir-version-release/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.17...v0.1.0
[0.0.1-beta.17]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.16...v0.0.1-beta.17
[0.0.1-beta.16]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.15...v0.0.1-beta.16
[0.0.1-beta.15]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.14...v0.0.1-beta.15
[0.0.1-beta.14]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.13...v0.0.1-beta.14
[0.0.1-beta.13]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.12...v0.0.1-beta.13
[0.0.1-beta.12]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.12...v0.0.1-beta.12
[0.0.1-beta.12]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.12...v0.0.1-beta.12
[0.0.1-beta.12]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.11...v0.0.1-beta.12
[0.0.1-beta.11]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.10...v0.0.1-beta.11
[0.0.1-beta.10]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.9...v0.0.1-beta.10
[0.0.1-beta.9]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.8...v0.0.1-beta.9
[0.0.1-beta.8]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.7...v0.0.1-beta.8
[0.0.1-beta.7]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.6...v0.0.1-beta.7
[0.0.1-beta.6]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.5...v0.0.1-beta.6
[0.0.1-beta.5]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.4...v0.0.1-beta.5
[0.0.1-beta.4]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.3...v0.0.1-beta.4
[0.0.1-beta.3]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.2...v0.0.1-beta.3
[0.0.1-beta.2]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.1...v0.0.1-beta.2
[0.0.1-beta.1]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1-beta.1...v0.0.1-beta.1
[0.0.1]: https://github.com/bulld0zer/elixir-version-release/compare/v0.0.1...v0.0.1-beta.0