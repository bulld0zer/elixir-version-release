defmodule VersionRelease.Changelog do
  require Logger

  alias VersionRelease.Config

  # Update changelog
  def update(
        %{
          dry_run: false,
          error: false,
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
          error: false,
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
          error: false,
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
          error: false,
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

  def get_release_changes(
        %{
          changelog:
            %{
              replacements: replacements
            } = changelog
        } = config
      ) do

    vars = [
      {:version, Config.get_prev_release_str(config)},
      {:date, "(*.)"},
      {:tag_name, Config.get_prev_release_tag_str(config)}
    ]

    %{file: file, patterns: patterns} =
      replacements |> Enum.find(fn r -> Map.get(r, :type, nil) == :changelog end)

    %{
      replace: release_pattern,
      search: unreleased_pattern
    } = patterns |> Enum.find(fn r -> Map.get(r, :type, nil) == :unreleased end)


    release_pattern = release_pattern |> inject_vars(vars)
    release_pattern = case config.prev_release do
      nil -> unreleased_pattern
      _ -> release_pattern
    end

    {:ok, changelog_contents} = File.read(file)

    {start, _s_len} = :binary.match(changelog_contents, unreleased_pattern)
    start = start + byte_size(unreleased_pattern)
    {finish, _f_len} = :binary.match(changelog_contents |> binary_part(start, byte_size(changelog_contents) - start), release_pattern)

    %{
      patch: patch,
      minor: minor,
      major: major
    } =
      changelog_contents
      |> binary_part(start, finish)
      |> String.replace("\r\n", "\n")
      |> String.split("\n", trim: true)
      |> Enum.filter(fn line -> line != "" end)
      |> List.delete_at(0)
      |> List.delete_at(-1)
      |> Enum.reduce(
        %{
          target: :patch,
          patch: [],
          minor: [],
          major: []
        },
        fn line, acc -> release_changes_reductor(line, acc, config) end
      )

    changelog = Map.put(changelog, :changes, %{patch: patch, minor: minor, major: major})


    Map.put(config, :changelog, changelog)
  end

  defp release_changes_reductor(
         line,
         %{
           patch: patch,
           minor: minor,
           major: major
         } = acc,
         %{
           changelog: %{
             minor_patterns: minor_patterns,
             major_patterns: major_patterns
           }
         }
       ) do
    is_header = line |> String.starts_with?("#")
    is_minor = line |> String.downcase() |> String.contains?(minor_patterns)
    is_major = line |> String.downcase() |> String.contains?(major_patterns)

    %{target: target} =
      acc =
      %{
        line: line,
        is_header: is_header,
        is_minor: is_minor,
        is_major: is_major
      }
      |> case do
        %{is_header: true, is_minor: true} -> Map.put(acc, :target, :minor)
        %{is_header: true, is_major: true} -> Map.put(acc, :target, :major)
        %{is_header: true} -> Map.put(acc, :target, :patch)
        _ -> acc
      end

    %{target: target, is_header: is_header, is_major: is_major}
    |> case do
      %{is_header: true} ->
        acc

      %{is_major: true, target: target} when target != :major ->
        Map.put(acc, :major, [line | major])

      %{target: :patch} ->
        Map.put(acc, :patch, [line | patch])

      %{target: :minor} ->
        Map.put(acc, :minor, [line | minor])

      %{target: :major} ->
        Map.put(acc, :major, [line | major])
    end
  end
end
