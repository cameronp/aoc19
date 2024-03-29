defmodule AdventOfCode.Day01 do
  import Utils, only: [lines: 2]
  import String, only: [to_integer: 1]
  import Enum, only: [map: 2, sum: 1]

  def part1(input) do
    input |> modules() |> map(&fuel_required/1) |> sum()
  end

  def part2(input) do
    input |> modules() |> map(&fuel_for_fuel/1) |> sum()
  end

  def modules(input) do
    input
    |> lines(&to_integer/1)
  end

  def fuel_required(mass) do
    div(mass, 3) - 2
  end

  def fuel_for_fuel(mass) when div(mass, 3) < 3, do: 0

  def fuel_for_fuel(mass) do
    fuel = fuel_required(mass)
    fuel + fuel_for_fuel(fuel)
  end
end
