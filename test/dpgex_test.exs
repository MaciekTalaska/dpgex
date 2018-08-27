defmodule DpgexTest do
  use ExUnit.Case
  doctest Dpgex

  test "greets the world" do
    assert Dpgex.hello() == :world
  end

  test "random number(0,0) returns 0" do
    assert Dpgex.Crypto.get_random_number(0, 0) == 0
  end

  test "get_random_number(0,1) returns 0 or 1" do
    assert Dpgex.Crypto.get_random_number(0, 1) <= 1
  end

  test "get_random_numbers(0,1,x) returns x 0s" do
    count = Dpgex.Crypto.get_random_number(0, 255)
    random_numbers = Dpgex.Crypto.get_random_numbers(0, 0, count)
    all_0s = Enum.filter(random_numbers, fn x -> x == 0 end)
    all_1s = Enum.filter(random_numbers, fn x -> x == 1 end)
    assert length(all_0s) + length(all_1s) == count
  end

end
