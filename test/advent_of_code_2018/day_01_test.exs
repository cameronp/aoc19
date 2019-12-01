defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  test "examples" do
    assert fuel_required(12) == 2
    assert fuel_required(14) == 2
    assert fuel_required(1969) == 654
    assert fuel_required(100_756) == 33583
  end

  test "part1" do
    input = "inputs/day1.txt"
    result = part1(input)

    assert result == 3_443_395
  end

  test "examples part 2" do
    assert fuel_for_fuel(12) == 2
    assert fuel_for_fuel(14) == 2
    assert fuel_for_fuel(1969) == 966
    assert fuel_for_fuel(100_756) == 50346
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
