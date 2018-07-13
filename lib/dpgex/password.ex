defmodule Dpgex.Password do
  def get_random_word(language) do
    repository = Dpgex.DicewareRepository.get_repository language
    index = Dpgex.Crypto.get_random_number 0, repository[:length]-1
    repository[:words]
    |> Enum.at(index)
  end

  def get_random_words(language, words_count) do
    repository = Dpgex.DicewareRepository.get_repository language
    words = Map.get(repository, :words)
    Dpgex.Crypto.get_random_elements(words, words_count)
  end

  def get_password(language, words_count, separator) do
    get_random_words(language, words_count)
    |> Enum.join(separator)
  end

  def get_all_passwords(language, words_count, separator, passwords_count) do
    Enum.to_list 1..passwords_count
    |> Enum.map(fn _ -> get_password(language, words_count, separator) end)
  end
end
