defmodule Dpgex.Password do
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

  def get_password(language, words_count, separator) do
    get_random_words(language, words_count)
    |> Enum.join(separator)
  end

  def get_all_passwords(language, words_count, separator, passwords_count) do
    Enum.to_list 1..passwords_count
    |> Enum.map(fn x -> get_password(language, words_count, separator) end)
  end
end
