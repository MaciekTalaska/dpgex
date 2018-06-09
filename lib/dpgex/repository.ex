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
  end

  defp get_english_words do
    english_diceware_list()
    |> String.split("\n")
    |> Enum.map(fn x -> x
    |> String.slice(5..-1) end)
  end

  def read_diceware_list(language) do
    case language do
      "pl" -> get_polish_words()
      _ -> get_english_words()
    end
  end
end
