defmodule Dpgex.Crypto do

  # the code is based on: https://hashrocket.com/blog/posts/the-adventures-of-generating-random-numbers-in-erlang-and-elixir

  @moduledoc """
  Crypto module - abstraction over :rand.
  Uses exs1024s algorithm and :rand.seed

  Provides following functions:

  - get_random_numbner(min, max)
  - get_random_numbers(min, max, count)
  - get_random_elements(list, count)
  """

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

  @doc """
  Returns single random number. Number returned is within the range `min` and `max` (inclusive).

  `get_random_number` uses cryptographically secure random generator. This requires extra initialization, and thus `get_random_number` should not be used to generate many random numbers. If there is a need to generate many random numbers at once `get_random_numbers` should be used instead.
  """
  @spec get_random_number(integer, integer) :: integer
  def get_random_number(min, max) do
    init()
    random_number(min, max)
  end

  @doc """
  Returns list of random numbers. The size of the list returned is equal to the `count` parameter.
  Returned numbers are from the range `min` and `max` (inclusive).
  This function uses cryptographically secure random number generator.
  """
  @spec get_random_numbers(integer, integer, integer) :: [integer]
  def get_random_numbers(min, max, count) do
    init()
    for _ <- 1..count, do: get_random_number(min, max)
  end

  @doc """
  Returns specified number of random elements from the list provided as parameter. This function uses cryptographically secure random number generator.
  """
  @spec get_random_elements([any], integer) :: [any]
  def get_random_elements([], _) do [] end
  def get_random_elements(_, 0) do [] end
  def get_random_elements([], 0) do [] end
  def get_random_elements(list, count) do
    init()
    Enum.take_random(list, count)
    #length = Kernel.length(list)
    # TODO: is Enum.take_random should be a good replacement here...
    #indices = get_random_numbers(0, length-1, count)
    #indices |> Enum.map(fn _ -> Enum.random(list) end)
  end
end
