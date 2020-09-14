defmodule VersionRelease.Config do
  require Logger

  def create(flags) do
    # print_help()
    flags =
      OptionParser.parse(flags,
        aliases: [
          d: :dry_run
        ],
        strict: [
          dry_run: :boolean,
          tag_prefix: :string,
          skip_push: :boolean,
          skip_publish: :boolean,
          skip_dev_version: :boolean,
          skip_merge: :boolean
        ]
      )

    %{
      dry_run: false,
      current_version: get_version(),
      tag_prefix: get_tag_prefix(),
      hex_publish: get_hex_publish_setting(),
      git_push: get_git_push_setting(),
      dev_version: get_dev_version_setting(),
      changelog: %{
        creation: get_changelog_creation_setting(),
        replacements: get_changelog_replacements_setting()
      },
      merge: get_merge_config()
    }
    |> add_flags(flags)
  end

  def print_help() do
    IO.puts(~S"""

    Usage: mix version.[level] [--dry-run | -d] [--skip-push]

    Levels: 
      major   - Bump major version
      minor   - Bump minor version
      patch   - Bump patch version
      rc      - Create/Bump to release candidate version
      beta    - Create/Bump to beta version
      alpha   - Create/Bump to alpha version

    Flags:
      --dry-run, -d       - Perform a dry run (no writes, just steps)
      --tag-prefix        - Prefix of git tag
      --skip-push         - Disable git push at the end
      --skip-publish      - Disable publish to Hex.pm
      --skip-dev-version  - Will not bump version after release
      --skip-merge        - Will skip mergers 
    """)
  end

  defp add_flags(config, {parsed, _argv, []}) do
    insert_params(config, parsed)
  end

  defp add_flags(_config, {_parsed, _argv, errors}) do
    IO.puts("Incorrect options")
    IO.puts(inspect(errors))
    print_help()
    System.halt(0)
  end

  defp insert_params(config, []) do
    config
  end

  defp insert_params(config, [flag | rest]) do
    config
    |> insert_param(flag)
    |> insert_params(rest)
  end

  defp insert_param(config, flag) do
    flag
    |> case do
      {:skip_publish, val} ->
        Map.put(config, :hex_publish, !val)

      {:skip_push, val} ->
        Map.put(config, :git_push, !val)

      {:dry_run, val} ->
        Map.put(config, :dry_run, val)

      {:tag_prefix, val} ->
        Map.put(config, :tag_prefix, val)

      {:skip_dev_version, val} ->
        Map.put(config, :dev_version, !val)

      {:skip_merge, true} ->
        Map.put(config, :merge, nil)

      _ ->
        print_help()
        System.halt(0)
    end
  end

  defp get_tag_prefix() do
    :version_release
    |> Application.get_env(:tag_prefix)
    |> case do
      prefix when is_binary(prefix) -> prefix
      _ -> nil
    end
  end

  defp get_version() do
    Mix.Project.config()[:version]
    |> String.split(".")
    |> case do
      [major, minor, patch] ->
        %{
          major: major |> Integer.parse() |> elem(0),
          minor: minor |> Integer.parse() |> elem(0),
          patch: patch |> Integer.parse() |> elem(0)
        }

      [major, minor, patch_and_ext, pre] ->
        [patch, ext] = patch_and_ext |> String.split("-")

        %{
          major: major |> Integer.parse() |> elem(0),
          minor: minor |> Integer.parse() |> elem(0),
          patch: patch |> Integer.parse() |> elem(0),
          pre_release: %{
            version: pre |> Integer.parse() |> elem(0),
            extension: ext
          }
        }
    end
  end

  defp get_changelog_creation_setting() do
    :version_release
    |> Application.get_env(:changelog)
    |> Map.get(:creation)
    |> case do
      :manual -> :manual
      :auto -> :auto
      _ -> :disabled
    end
  end

  defp get_changelog_replacements_setting() do
    :version_release
    |> Application.get_env(:changelog)
    |> Map.get(:replacements)
    |> case do
      replacements when is_list(replacements) -> replacements
      _ -> nil
    end
  end

  defp get_hex_publish_setting() do
    :version_release
    |> Application.get_env(:hex_publish)
    |> case do
      true -> true
      _ -> false
    end
  end

  defp get_git_push_setting() do
    :version_release
    |> Application.get_env(:git_push)
    |> case do
      false -> false
      _ -> true
    end
  end

  defp get_dev_version_setting() do
    :version_release
    |> Application.get_env(:dev_version)
    |> case do
      false -> false
      _ -> true
    end
  end

  defp get_merge_config() do
    :version_release
    |> Application.get_env(:merge)
  end

  def get_current_version_str(%{
        current_version: %{
          major: major,
          minor: minor,
          patch: patch,
          pre_release: %{
            version: pre_ver,
            extension: pre_ext
          }
        }
      }) do
    "#{major}.#{minor}.#{patch}-#{pre_ext}.#{pre_ver}"
  end

  def get_current_version_str(%{
        current_version: %{
          major: major,
          minor: minor,
          patch: patch
        }
      }) do
    "#{major}.#{minor}.#{patch}"
  end

  def get_current_tag_str(
        %{
          tag_prefix: tag_prefix
        } = config
      ) do
    "#{tag_prefix}#{get_current_version_str(config)}"
  end

  def get_new_version_str(%{
        new_version: %{
          major: major,
          minor: minor,
          patch: patch,
          pre_release: %{
            version: pre_ver,
            extension: pre_ext
          }
        }
      }) do
    "#{major}.#{minor}.#{patch}-#{pre_ext}.#{pre_ver}"
  end

  def get_new_version_str(%{
        new_version: %{
          major: major,
          minor: minor,
          patch: patch
        }
      }) do
    "#{major}.#{minor}.#{patch}"
  end

  def get_new_tag_str(
        %{
          tag_prefix: tag_prefix
        } = config
      ) do
    "#{tag_prefix}#{get_new_version_str(config)}"
  end

  def get_date_str() do
    {{year, month, date}, _} = :calendar.local_time()
    "#{year}-#{month}-#{date}"
  end
end
