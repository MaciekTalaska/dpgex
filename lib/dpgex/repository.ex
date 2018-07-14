defmodule Dpgex.DicewareRepository do
  @external_resource "priv/diceware-pl.txt"
  @pl_diceware File.read! "priv/diceware-pl.txt"
  defp polish_diceware_list, do: @pl_diceware

  @external_resource "priv/diceware-en.txt"
  @en_diceware File.read! "priv/diceware-en.txt"
  defp english_diceware_list, do: @en_diceware

  defp extract_words_from_file_content(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(fn x -> x |> String.split |> List.last end)
    |> Enum.drop(-1)
  end

  defp repository_from_content(lines) do
    words = extract_words_from_file_content(lines)
    %{ :length => Kernel.length(words),
       :words => extract_words_from_file_content(lines)
    }
  end

  defp extract_language_from_filename(filename) do
    filename
    |> String.downcase
    # Piping to the second argument taken from: https://shulhi.com/piping-to-second-argument-in-elixir/
    |> (&Regex.named_captures(
          ~r/(?<p>diceware-)(?<language>[a-z]{2})(?<ext>.*)/,
        &1)).()
    |> Map.get("language")
  end

  defp get_local_diceware_files() do
    files = case File.ls do
              {:error, reason} -> throw reason
              {:ok, files} -> files
            end
    files |> Enum.filter(fn x -> x |> String.contains?("diceware-") end)
  end

  defp available_languages_from_files do
    get_local_diceware_files()
    |> Enum.map( fn f -> {f |> extract_language_from_filename(),f} end)
  end

  defp repository_from_file(filename) do
    file_content = case File.read filename do
      {:error, reason } -> throw reason
      {:ok, body} -> body
    end

    language = extract_language_from_filename(filename)

    {String.to_atom(language),
      repository_from_content(file_content)
    }
  end

  defp repositories_from_local_files do
    get_local_diceware_files()
    |> Enum.map(fn f -> f |> repository_from_file end)
  end

  def get_all_repositories do
    inner = [
      pl: repository_from_content(polish_diceware_list()),
      en: repository_from_content(english_diceware_list())
    ]
    local = repositories_from_local_files()
    inner ++ local
  end

  defp repository_from_file_by_language(language) do
    languages = available_languages_from_files()
    language_file = languages |> Enum.find(fn ls -> elem(ls, 0) == language end)
    case language_file == nil do
      true -> {:error, :enoent}
      false ->
        {_, filename} = language_file
        {_, repo_content} = repository_from_file(filename)
        {:ok, repo_content}
    end
  end

  defp read_diceware_list(language) do
    case language do
      "pl" -> {:ok,
              repository_from_content(polish_diceware_list()) }
      "en" -> {:ok,
              repository_from_content(english_diceware_list())}
       _ -> repository_from_file_by_language(language)
    end
  end

  def get_supported_languages do
    languages_from_files = available_languages_from_files()
      |> Enum.map(fn l -> elem(l, 0) end)
    ["pl", "en"] ++ languages_from_files
  end

  def get_repository(language) do
    case read_diceware_list language do
      {:ok, body} -> body
      {:error, _} -> nil
    end
  end
end
