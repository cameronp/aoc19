defmodule AdventOfCode.Day05 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    cpu =
      input
      |> Memory.load()
      |> Cpu.boot()
      |> Cpu.preload_input([1])
      |> Intcode.IO.run()

    cpu.output |> hd()
  end

  def part2(input) do
    cpu =
      input
      |> Memory.load()
      |> Cpu.boot()
      |> Cpu.preload_input([5])
      |> Intcode.IO.run()

    cpu.output |> hd()
  end
end
