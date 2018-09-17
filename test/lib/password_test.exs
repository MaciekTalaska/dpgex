defmodule DpgexPasswordTest do
  use ExUnit.Case

  test "get_random_word should return non-empty string" do
    word = Dpgex.Password.get_random_word("pl")
    assert is_binary(word) && is_bitstring(word)
    # no word in default dictionary is shorter than 3 characters
    assert String.length(word) > 3
  end


  test "get_random_words(_lang, X) should return X words" do
    count = Dpgex.Crypto.get_random_number(0, 255)
    words = Dpgex.Password.get_random_words("pl", count)
    assert length(words) == count
  end
end

