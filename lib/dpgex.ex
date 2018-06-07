defmodule Dpgex do
  @moduledoc """
  Documentation for Dpgex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dpgex.hello
      :world

  """
  def hello do
    :world
  end


  @external_resource "priv/diceware-pl.txt"
  @pl_diceware File.read! "priv/diceware-pl.txt"
  def polish_diceware_list, do: @pl_diceware

  @external_resource "priv/diceware-en.txt"
  @en_diceware File.read! "priv/diceware-en.txt"
  def english_diceware_list, do: @en_diceware
end

