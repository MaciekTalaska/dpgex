defmodule Dpgex.Dices do

  def throw_dice do
    :crypto.rand_uniform 1, 6
  end

  def throw_dices(dices) do
    Enum.to_list 1..dices |> Enum.map( fn x -> :crypto.rand_uniform 1,6 end)
  end
end
