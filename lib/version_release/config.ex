defmodule VersionRelease.Config do
  require Logger

  def create(flags) do
    # print_help()
    %{
      dry_run: false,
      current_version: get_version(),
      tag_prefix: get_tag_prefix(),
      hex_publish: get_hex_publish_setting() 
      changelog: %{
        creation: get_changelog_creation_setting(),
        replacements: get_changelog_replacements_setting()
      }
    }
    |> parse_flags(flags)
  end

  defp print_help() do
    IO.puts(~S"""

    Supported flags:
      --dry-run
      --isolated

    """)
  end

  defp parse_flags(config, []) do
    config
  end

  defp parse_flags(config, [flag | rest]) do
    config
    |> insert_param(flag)
    |> parse_flags(rest)
  end

  defp insert_param(config, flag) do
    %{
      "--dry-run" => :dry_run,
      "--isolated" => :isolated
    }[flag]
    |> case do
      nil ->
        print_help()
        System.halt(0)

      flag ->
        Map.put(config, flag, true)
    end
  end

  defp get_tag_prefix() do
    :version_release
    |> Application.get_env(:teg_prefix)
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
