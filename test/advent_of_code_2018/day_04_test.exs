defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Day04

  test "part1" do
    input = {172_930, 683_082}
    result = part1(input)

    assert result == 1675
  end

  test "part2" do
    input = {172_930, 683_082}
    result = part2(input)

    assert result == 1142
  end
end
