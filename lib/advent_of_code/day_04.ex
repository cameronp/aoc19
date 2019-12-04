defmodule AdventOfCode.Day04 do
  alias Utils.List, as: L

  def part1({start, finish}), do: start..finish |> Enum.count(&valid?/1)

  def part2({start, finish}), do: start..finish |> Enum.count(&extra_valid?/1)

  defp valid?(number), do: double_digits?(number) && ascending?(number)

  defp extra_valid?(number), do: valid?(number) && double_digits_isolated?(number)

  defp double_digits?(number), do: Integer.digits(number) |> L.has_doubled_elements?()

  defp double_digits_isolated?(number), do: Integer.digits(number) |> L.has_isolated_double?()

  defp ascending?(number), do: Integer.digits(number) |> L.is_sorted?()
end
