defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1 examples" do
    input = "inputs/day3-ex1.txt"
    result = part1(input)
    assert result == 6

    input = "inputs/day3-ex2.txt"
    result = part1(input)
    assert result == 159

    input = "inputs/day3-ex3.txt"
    result = part1(input)
    assert result == 135
  end

  test "part1" do
    input = "inputs/day3.txt"
    result = part1(input)

    assert result == 225
  end

  test "part2" do
    input = "inputs/day3.txt"
    result = part2(input)

    assert result == 35194
  end
end
