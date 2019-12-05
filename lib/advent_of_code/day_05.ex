defmodule AdventOfCode.Day05 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    run_test(input, 1)
  end

  def part2(input) do
    run_test(input, 5)
  end

  defp run_test(program, input) do
    cpu =
      program
      |> Memory.load()
      |> Cpu.boot()
      |> Cpu.preload_input([input])
      |> Intcode.IO.run()

    cpu.output |> hd()
  end
end
