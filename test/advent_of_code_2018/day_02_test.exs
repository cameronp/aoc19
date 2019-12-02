defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02
  alias Intcode.{Cpu, Memory}

  @input "inputs/day2.txt"

  test "examples part 1" do
    r1 = [1, 0, 0, 0, 99] |> Memory.to_map() |> Cpu.boot() |> Cpu.run() |> Cpu.dump()
    assert r1 == [2, 0, 0, 0, 99]

    r2 = [2, 3, 0, 3, 99] |> Memory.to_map() |> Cpu.boot() |> Cpu.run() |> Cpu.dump()
    assert r2 == [2, 3, 0, 6, 99]

    r3 = [2, 4, 4, 5, 99, 0] |> Memory.to_map() |> Cpu.boot() |> Cpu.run() |> Cpu.dump()
    assert r3 == [2, 4, 4, 5, 99, 9801]

    r4 =
      [1, 1, 1, 4, 99, 5, 6, 0, 99]
      |> Memory.to_map()
      |> Cpu.boot()
      |> Cpu.run()
      |> Cpu.dump()

    assert r4 == [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end

  test "part1" do
    result = part1(@input)

    assert result == 3_654_868
  end

  test "part2" do
    result = part2(@input)

    assert result == {70, 14, 19_690_720}
  end
end
