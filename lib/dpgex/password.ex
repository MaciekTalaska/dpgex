defmodule Dpgex.Password do

  @moduledoc """
  Password library. Exposes several functions to generate random passwords using
  diceware method.

  This module uses `Dpgex.DicewareRepository` to read list of words which are the sources for the password generation.

  Functions in this module take language as a paramter (one of). Language should be provided as 2-letter string (for example: es for Spanish, en for English, de for German etc.)
  """

  @doc """
  Returns single, randomly picked word from the list of words provivded for the specified language. Word is selected using cryptographically secure random generator.

  Language should be provided as 2-letter string which identifies language as described in ISO 639-1 (for example: "es" for Spanish, "en" for English, "de" for German etc.)

  ## Examples

      iex> Dpgex.Password.get_random_word("pl")
      "kulka"

      iex> Dpgex.Password.get_random_word("en")
      "rugby"
  """
  @spec get_random_word(String) :: String
  def get_random_word(language) do
    repository = Dpgex.DicewareRepository.get_repository! language
    index = Dpgex.Crypto.get_random_number 0, repository[:length]-1
    repository[:words]
    |> Enum.at(index)
  end

  @doc """
  Returns list of random words in selected language.

  Language should be provided as 2-letter string which identifies language as described in ISO 639-1 (for example: "es" for Spanish, "en" for English, "de" for German etc.)

  ## Examples

      iex> Dpgex.Password.get_random_words("pl", 2)
      ["kipu", "zapora"]

      iex> Dpgex.Password.get_random_words("en", 3)
      ["dryer", "senator", "utility"]
  """
  @spec get_random_words(String, integer) :: String
  def get_random_words(language, words_count) do
    repository = Dpgex.DicewareRepository.get_repository! language
    words = Map.get(repository, :words)
    Dpgex.Crypto.get_random_elements(words, words_count)
  end

  @doc """
  Returns password consisting of specified number of words in selected language. Words are randomly selected from the list of all words provided for the specified language. Function uses cryptographically secure random number generator.

  Language should be provided as 2-letter string which identifies language as described in ISO 639-1 (for example: "es" for Spanish, "en" for English, "de" for German etc.)

  ## Examples

      iex> Dpgex.Password.get_password("pl", 3, ".")
      "gburek.errata.wozak"

      iex> Dpgex.Password.get_password("en", 4, "-")
      "nebula-refinery-groundhog-happiness"
  """
  @spec get_password(String, integer, Char) :: [String]
  def get_password(language, words_count, separator) do
    get_random_words(language, words_count)
    |> Enum.join(separator)
  end

  @doc """
  Returns specified number of passwords, each one containing specified number of words from the specified language. Words forming passwords are separated using the character provided as separator.

  Language should be provided as 2-letter string which identifies language as described in ISO 639-1 (for example: "es" for Spanish, "en" for English, "de" for German etc.)

  ## Examples

      iex> Dpgex.Password.get_all_passwords("pl", 3, "*", 4)
      ["nadruk*pompon*botek", "rytm*trasa*kwitek", "nazwa*tragik*agenda",
      "kefir*wdech*kubrak"]

      iex> Dpgex.Password.get_all_passwords("en", 4, "|", 2)
      ["spyglass|username|pacemaker|agnostic", "boiler|fryingpan|joystick|copier"]
  """
  @spec get_all_passwords(String, integer, Char, integer) :: [String]
  def get_all_passwords(language, words_count, separator, passwords_count) do
    Enum.to_list 1..passwords_count
    |> Enum.map(fn _ -> get_password(language, words_count, separator) end)
  end
end
