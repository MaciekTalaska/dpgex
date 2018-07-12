defmodule Dpgex.Crypto do

  def get_random_number(min, max) do
    :crypto.rand_uniform min, max
  end

  def get_random_numbers(min, max, count) do
    Enum.to_list 1..count
      |> Enum.map(fn _ -> get_random_number(min, max) end)
  end

  def throw_dice do
    :crypto.rand_uniform 1, 6
  end

  def throw_dices(dices) do
    Enum.to_list 1..dices |> Enum.map( fn _ -> :crypto.rand_uniform 1,6 end)
  end
end
