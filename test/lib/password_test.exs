defmodule DpgexPasswordTest do
  use ExUnit.Case

  test "get_random_word should return non-empty string" do
    word = Dpgex.Password.get_random_word("pl")
    assert is_binary(word) && is_bitstring(word)
    # no word in default dictionary is shorter than 3 characters
    assert String.length(word) > 3
  end


  test "get_random_words(_lang, X) should return X words" do
    count = Dpgex.Crypto.get_random_number(0, 10)
    words = Dpgex.Password.get_random_words("pl", count)
    assert length(words) == count
  end

  test "get_password should return specified number of words" do
    count = Dpgex.Crypto.get_random_number(0, 10)
    separator = "-"
    password = Dpgex.Password.get_password("pl", count, separator)
    words = String.split(password, separator)
    assert length(words) == count
  end

  test "get_all_passwords should return required number of passwords" do
    passwords_count = Dpgex.Crypto.get_random_number(0, 10)
    password_length = Dpgex.Crypto.get_random_number(0, 10)
    separator = "."
    passwords = Dpgex.Password.get_all_passwords("pl", password_length, separator, passwords_count)
    assert length(passwords) == passwords_count
  end
end

