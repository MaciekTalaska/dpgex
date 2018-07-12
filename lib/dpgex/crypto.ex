defmodule Dpgex.Crypto do

  def get_random_number(min, max) do
    :crypto.rand_uniform min, max
  end

  def get_random_numbers(min, max, count) do
    Enum.to_list 1..count
      |> Enum.map(fn _ -> get_random_number(min, max) end)
  end
end
