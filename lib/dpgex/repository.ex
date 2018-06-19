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
        {:error, _} -> throw("Unable to open specified language list")
    end
  end
end
