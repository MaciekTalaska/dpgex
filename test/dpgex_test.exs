defmodule DpgexTest do
  use ExUnit.Case
  doctest Dpgex

  test "greets the world" do
    assert Dpgex.hello() == :world
  end

  test "get_random_number(0,0) should return 0" do
    assert Dpgex.Crypto.get_random_number(0, 0) == 0
  end

  test "get_random_number(1, 1) should return 1" do
    assert Dpgex.Crypto.get_random_number(1, 1) == 1
  end

  test "get_random_number(n, n) should return n" do
    number = Dpgex.Crypto.get_random_number(1, 255)
    assert Dpgex.Crypto.get_random_number(number, number) == number
  end

  test "get_random_number(0, 1) returns 0 or 1" do
    assert Dpgex.Crypto.get_random_number(0, 1) <= 1
  end

  test "get_random_numbers(0, 0, x) returns x 0s" do
    count = Dpgex.Crypto.get_random_number(1, 255)
    random_numbers = Dpgex.Crypto.get_random_numbers(0, 0, count)
    all_0s = Enum.filter(random_numbers, fn x -> x == 0 end)
    all_1s = Enum.filter(random_numbers, fn x -> x == 1 end)
    assert length(all_0s) == count
    assert length(all_1s) == 0
  end

  test "get_random_numbers(0, 1, x) returns x 0s" do
    count = Dpgex.Crypto.get_random_number(1, 255)
    random_numbers = Dpgex.Crypto.get_random_numbers(0, 0, count)
    all_0s = Enum.filter(random_numbers, fn x -> x == 0 end)
    all_1s = Enum.filter(random_numbers, fn x -> x == 1 end)
    assert length(all_0s) + length(all_1s) == count
  end

  test "get_random_elements([], _) should return empty list" do
    assert Dpgex.Crypto.get_random_elements([], Dpgex.Crypto.get_random_number(1, 255)) == []
  end

  test "get_random_elements(_, 0) should return empty list" do
    assert Dpgex.Crypto.get_random_elements([1,2,3], 0) == []
  end

  test "get_random_elements([], 0) should return empty list" do
    assert Dpgex.Crypto.get_random_elements([], 0) == []
  end

  test "get_random_elements([], count) should return count amount of random elements" do
    max = Dpgex.Crypto.get_random_number(1, 255)
    count = Dpgex.Crypto.get_random_number(1, 20)
    count10 = count * 10
    random_numbers = Dpgex.Crypto.get_random_numbers(1, max, count10)
    random_elements = Dpgex.Crypto.get_random_elements(random_numbers, count)
    assert random_elements |> Enum.all?(fn x -> Enum.member?(random_numbers, x) end)
  end

end
