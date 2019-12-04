defmodule AdventOfCode.Day04 do
  alias Utils.List, as: L

  def part1({start, finish}) do
    start..finish
    |> Enum.to_list()
    |> Enum.filter(&valid?/1)
    |> Enum.count()
  end

  def part2({start, finish}) do
    start..finish
    |> Enum.to_list()
    |> Enum.filter(&extra_valid?/1)
    |> Enum.count()
  end

  def valid?(number) do
    double_digits?(number) && ascending?(number)
  end

  def extra_valid?(number) do
    valid?(number) && double_digits_isolated?(number)
  end

  def double_digits?(number) do
    Integer.digits(number)
    |> L.has_doubled_elements?()
  end

  def double_digits_isolated?(number) do
    Integer.digits(number)
    |> L.has_isolated_double?()
  end

  def ascending?(number) do
    Integer.digits(number)
    |> L.is_sorted?()
  end
end
