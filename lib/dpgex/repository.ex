defmodule Dpgex.DicewareRepository do
  @external_resource "priv/diceware-pl.txt"
  @pl_diceware File.read! "priv/diceware-pl.txt"
  defp polish_diceware_list, do: @pl_diceware

  @external_resource "priv/diceware-en.txt"
  @en_diceware File.read! "priv/diceware-en.txt"
  defp english_diceware_list, do: @en_diceware

  defp get_polish_words do
    polish_diceware_list()
    |> String.split("\n")
    |> Enum.drop(-1)
  end

  defp get_english_words do
    english_diceware_list()
    |> String.split("\n")
    |> Enum.map( fn x -> x |> String.split |> List.last  end)
    |> Enum.drop(-1)
  end

  def extract_language_from_filename(filename) do
    filename
    |> String.downcase
    # Piping to the second argument taken from: https://shulhi.com/piping-to-second-argument-in-elixir/
    |> (&Regex.named_captures(
          ~r/(?<p>diceware-)(?<language>[a-z]{2})(?<ext>.*)/,
        &1)).()
    |> Map.get("language")
    #Map.get(result, "language")
  end

#  defp extract_language_from_filename(filename) do
#    result = Regex.named_captures(
#      ~r/(?<p>diceware-)(?<language>[a-z]{2})(?<ext>.*)/,
#      filename |> String.downcase)
#    Map.get(result, "language")
#  end

  defp get_local_diceware_files() do
    files = case File.ls do
              {:error, reason} -> throw reason
              {:ok, files} -> files
            end
    files |> Enum.filter(fn x -> x |> String.contains?("diceware-") end)
  end

  def from_file(filename) do
    file = case File.read filename do
      {:error, reason } -> throw reason
      {:ok, body} -> body
    end

    words = file |> String.split("\n")
    |> Enum.map(fn x -> x |> String.split |> List.last end)
    |> Enum.drop(-1)

    language = extract_language_from_filename(filename)

    {String.to_atom(language),
      %{:words => words,
      :length => Kernel.length(words),
      :language => language }}
  end

  def create_repository_from_local_files do
    get_local_diceware_files()
    |> Enum.map(fn f -> f |> from_file end)
  end

  def create_repository do
    inner = [
      pl: %{language: "pl", words: get_polish_words(), length: Kernel.length(get_polish_words())},
      en: %{language: "en", words: get_english_words(), length: Kernel.length(get_english_words())}
    ]
    local = create_repository_from_local_files()
    inner ++ local
  end


  defp read_diceware_list(language) do
    case language do
      "pl" -> { :ok, get_polish_words()}
      "en" -> { :ok, get_english_words()}
      _ -> {:error, :enoent}
    end
  end

  def get_repository(language) do
    case read_diceware_list language do
      {:ok, body} ->
        words = body
        length = words |> Kernel.length
        language = language
        %{words: words, length: length, language: language}
        {:error, _} -> throw("No entry for language: '#{language}' found")
    end
  end

  def get_repository_by_language(language) do
    repository = create_repository()
    repository[String.to_atom(language)]
  end
end
