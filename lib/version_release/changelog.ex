defmodule VersionRelease.Changelog do
  require Logger

  alias VersionRelease.Config

  # Update changelog
  def update(
        %{
          dry_run: false,
          wd_clean: true,
          changelog: %{
            creation: changelog_creation,
            replacements: replacements
          }
        } = config
      )
      when changelog_creation != :disabled do
    Logger.info("Updating changelog")

    do_replacemetns(config, replacements)

    config
  end

  # Perform a dry run
  def update(
        %{
          dry_run: true,
          wd_clean: true,
          changelog: %{
            creation: changelog_creation,
            replacements: _replacements
          }
        } = config
      )
      when changelog_creation != :disabled do
    Logger.info("Updating changelog")
    config
  end

  # Do nothing
  def update(config) do
    config
  end

  def pre_release_update(
        %{
          dry_run: false,
          wd_clean: true,
          changelog: %{
            creation: changelog_creation,
            pre_release_replacements: replacements
          }
        } = config
      )
      when changelog_creation != :disabled do
    Logger.info("Updating changelog (prerelease)")

    do_replacemetns(config, replacements)

    config
  end

  # Perform a dry run
  def pre_release_update(
        %{
          dry_run: true,
          wd_clean: true,
          changelog: %{
            creation: changelog_creation,
            pre_release_replacements: _replacements
          }
        } = config
      )
      when changelog_creation != :disabled do
    Logger.info("Updating changelog (prerelease)")
    config
  end

  # Do nothing
  def pre_release_update(config) do
    config
  end

  defp do_replacemetns(config, []) do
    config
  end

  defp do_replacemetns(config, [replacement | rest]) do
    vars = [
      {:version, Config.get_new_version_str(config)},
      {:date, Config.get_date_str()},
      {:tag_name, Config.get_new_tag_str(config)}
    ]

    replace(replacement, vars)
    do_replacemetns(config, rest)
    config
  end

  defp replace(%{file: file, patterns: patterns}, vars) do
    file
    |> File.read()
    |> case do
      {:ok, body} ->
        replaced = replace_pattern(body, patterns, vars)

        {:ok, file_pid} = File.open(file, [:write])
        IO.write(file_pid, replaced)
        File.close(file_pid)

      error ->
        Logger.error("Error opening #{file} #{inspect(error)}")
    end
  end

  defp replace_pattern(body, [], _vars) do
    body
  end

  defp replace_pattern(body, [%{search: search, replace: replace} | rest], vars) do
    body
    |> String.replace(search, replace |> inject_vars(vars))
    |> replace_pattern(rest, vars)
  end

  defp replace_pattern(body, [%{search: search, replace: replace, global: global} | rest], vars) do
    body
    |> String.replace(search, replace |> inject_vars(vars), global: global)
    |> replace_pattern(rest, vars)
  end

  defp inject_vars(str, []) do
    str
  end

  defp inject_vars(str, [{search, replace} | rest]) do
    str
    |> String.replace("{{#{search}}}", replace, global: true)
    |> inject_vars(rest)
  end
end
