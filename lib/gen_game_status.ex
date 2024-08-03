defmodule GenGameStatus do
  @status_filename "status.toml"

  defp format_to_toml(files) do
    """
    [COMPLETED]

    [PROGRESS]

    [PLAYING]

    [NOT PLAYED]
    #{files}
    """
  end

  def main(path) do
    if File.dir?(path) do
      case path |> File.cd() do
        :ok ->
          :ok

        {:error, reason} ->
          exit(reason)
      end
    end

    files =
      case File.ls() do
        {:ok, files} ->
          files
          |> Enum.filter(&file_not_toml/1)
          |> Enum.map(&Path.basename/1)
          |> Enum.join("\n")

        {:error, reason} ->
          exit(reason)
      end

    with_file_handling(@status_filename, fn ->
      File.write(@status_filename, format_to_toml(files))
    end)
  end

  defp file_not_toml(file), do: Path.extname(file) != ".toml"

  defp with_file_handling(filename, callback) do
    if File.exists?(filename) do
      prompt_for_overwrite(filename, callback)
    else
      callback.()
    end
  end

  defp prompt_for_overwrite(filename, callback) do
    answer =
      "Rewrite an existing file? [y/n]\n"
      |> IO.gets()
      |> String.trim()
      |> String.downcase()

    case answer do
      "y" -> callback.()
      "n" -> nil
      _ -> prompt_for_overwrite(filename, callback)
    end
  end
end
