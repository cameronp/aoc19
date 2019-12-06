defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "inputs/day6.txt"
    result = part1(input)

    assert result == 145_250
  end

  test "part2" do
    input = "inputs/day6.txt"
    result = part2(input)

    assert result == 274
  end
end
