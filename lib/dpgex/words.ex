defmodule Dpgex.Words do
  def get_random_word(language) do
    repository = Dpgex.DicewareRepository.get_repository language
    index = :crypto.rand_uniform 0, repository[:length]-1
    repository[:words]
    |> Enum.at(index)
  end

  def get_random_words(language, words) do
    Enum.to_list 1..words
    |> Enum.map(fn x -> get_random_word language end)
  end
end
