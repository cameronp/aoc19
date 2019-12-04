defmodule AdventOfCode.Day04 do
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
    |> list_has_doubled_elements?()
  end

  def double_digits_isolated?(number) do
    Integer.digits(number)
    |> list_has_isolated_double?()
  end

  def ascending?(number) do
    Integer.digits(number)
    |> list_is_sorted?()
  end

  def list_has_doubled_elements?([]), do: false
  def list_has_doubled_elements?([_]), do: false
  def list_has_doubled_elements?([a, a | _]), do: true
  def list_has_doubled_elements?([_ | t]), do: list_has_doubled_elements?(t)

  def list_is_sorted?(list), do: list == Enum.sort(list)

  def list_has_isolated_double?([]), do: false
  def list_has_isolated_double?([_]), do: false

  def list_has_isolated_double?([a, a | t]) do
    case t do
      [^a | _] -> skip(t, a) |> list_has_isolated_double?()
      _ -> true
    end
  end

  def list_has_isolated_double?([_ | t]), do: list_has_isolated_double?(t)

  def skip([], _val), do: []
  def skip([val1 | _] = list, val) when not (val == val1), do: list
  def skip([_ | t], val), do: skip(t, val)
end
