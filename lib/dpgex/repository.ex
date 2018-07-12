defmodule Dpgex.DicewareRepository do
  @external_resource "priv/diceware-pl.txt"
  @pl_diceware File.read! "priv/diceware-pl.txt"
  defp polish_diceware_list, do: @pl_diceware

  @external_resource "priv/diceware-en.txt"
  @en_diceware File.read! "priv/diceware-en.txt"
  defp english_diceware_list, do: @en_diceware

  defp extract_words_from_file_content(words) do
    words
    |> String.split("\n")
    |> Enum.map(fn x -> x |> String.split |> List.last end)
    |> Enum.drop(-1)
  end

  defp get_inner_diceware(lines) do
    words = extract_words_from_file_content(lines)
    %{ :length => Kernel.length(words),
       :words => extract_words_from_file_content(lines)
    }
  end

  def extract_language_from_filename(filename) do
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

  def get_supported_languages_from_files do
    get_local_diceware_files()
    |> Enum.map( fn f -> {f |> extract_language_from_filename(),f} end)
  end

  def from_file(filename) do
    file_content = case File.read filename do
      {:error, reason } -> throw reason
      {:ok, body} -> body
    end

    words = extract_words_from_file_content(file_content)
    language = extract_language_from_filename(filename)

    {String.to_atom(language),
      %{:words => words,
      :length => Kernel.length(words)}}
  end

  def create_repository_from_local_files do
    get_local_diceware_files()
    |> Enum.map(fn f -> f |> from_file end)
  end

  def get_all_repositories do
    inner = [
      pl: %{ words: extract_words_from_file_content(polish_diceware_list()),
             length: Kernel.length(extract_words_from_file_content(polish_diceware_list()))},
      en: %{ words: extract_words_from_file_content(english_diceware_list()),
             length: Kernel.length(extract_words_from_file_content(english_diceware_list()))}
    ]
    local = create_repository_from_local_files()
    inner ++ local
  end

  def get_language_data_from_file(language) do
    languages = get_supported_languages_from_files()
    exists = languages |> Enum.any?(fn ls -> elem(ls, 0) == language end)
    case exists do
      false -> {:error, :enoent}
      true -> {:ok, from_file(elem(languages |> Enum.find(fn l -> elem(l,0)==language end),1)) }
    end
  end

  defp read_diceware_list(language) do
    case language do
      "pl" -> {:ok,
              get_inner_diceware(polish_diceware_list()) }
      "en" -> {:ok,
              get_inner_diceware(english_diceware_list())}
       _ -> get_language_data_from_file(language)
    end
  end

  def get_repository(language) do
    case read_diceware_list language do
      {:ok, body} -> body
      {:error, _} -> throw("No entry for language: '#{language}' found")
    end
  end
end
