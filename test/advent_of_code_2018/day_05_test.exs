defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  test "part1" do
    input = "inputs/day5.txt"
    result = part1(input)

    assert result == 13_285_749
  end

  test "part2" do
    input = "inputs/day5.txt"
    result = part2(input)

    assert result == 5_000_972
  end
end
