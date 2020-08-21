# Version release for elixir
  Project version and changelog managment for elixir. Insparation for functionality is taken from [cargo-release](https://github.com/sunng87/cargo-release) package for Rust

  Performs release best-practices, including:

  * Ensure the git working directory is clean.
  * Bump the version in mix.exs
  * Create a git tag for this version
  * Run mix release (disabled by default)
  * Bump version for next development cycle
  * git push

## Install

Current release: 0.0.1-beta.7

Add to mix.exs
```
def deps do
  [
    ...other
    {:versin_release, 0.0.1-beta.2, only: :dev, runtime: false}
    ...other
  ]
end
```

## Usage

`mix version.[level]`

| level | description                                                      |
|-------|------------------------------------------------------------------|
| major | Creates major realease version. I.e. from 1.2.3 to 2.2.3         |
| minor | Creates minor realease version. I.e. from 1.2.3 to 1.3.3         |
| patch | Creates patch realease version. I.e. from 1.2.3 to 1.2.4         |
| alpha | Creates alpha realease version. I.e. from 1.2.3 to 1.2.4-alpha.0 |


### Prerequisite

* Your project should be managed by git.

## License

Licensed under [MIT license](LICENSE)