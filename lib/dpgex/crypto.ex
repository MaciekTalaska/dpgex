defmodule Dpgex.Crypto do

  # the code is based on: https://hashrocket.com/blog/posts/the-adventures-of-generating-random-numbers-in-erlang-and-elixir

  defp init do
    <<i1 :: unsigned-integer-32,
      i2 :: unsigned-integer-32,
      i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exs1024s, {i1, i2, i3})
  end

  defp random_number(min, max) do
    case min do
      0 -> :rand.uniform(max + 1) - 1
      _ -> :rand.uniform(max - min + 1) + min - 1
    end
  end

  def get_random_number(min, max) do
    init()
    random_number(min, max)
  end

  def get_random_numbers(min, max, count) do
    init()
    Enum.to_list 1..count
      |> Enum.map(fn _ -> get_random_number(min, max) end)
  end

  def get_random_elements(list, count) do
    length = Kernel.length(list)
    indices = get_random_numbers(0, length-1, count)
    indices |> Enum.map(fn _ -> Enum.random(list) end)
  end
end
