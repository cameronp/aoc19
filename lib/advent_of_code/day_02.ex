defmodule AdventOfCode.Day02 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    input
    |> Memory.load()
    |> Cpu.boot()
    |> Intcode.IO.execute_program(12, 2)
  end

  def part2(input) do
    input
    |> Memory.load()
    |> Cpu.boot()
    |> find_result(19_690_720)
  end

  def find_result(%Cpu{} = state, result) do
    for(n <- 0..255, v <- 0..255, do: {n, v, Intcode.IO.execute_program(state, n, v)})
    |> Enum.find(fn {_, _, r} -> r == result end)
  end
end
