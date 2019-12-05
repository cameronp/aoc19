defmodule AdventOfCode.Day02 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    input
    |> Memory.load()
    |> Cpu.boot()
    |> Intcode.IO.run(12, 2)
  end

  def part2(input) do
    input
    |> Memory.load()
    |> Cpu.boot()
    |> find_result(19_690_720)
  end

  def find_result(%Cpu{} = state, result) do
    for(
      n <- 0..(state.memory[:size] - 1),
      v <- 0..(state.memory[:size] - 1),
      do: {n, v, Intcode.IO.run(state, n, v)}
    )
    |> Enum.find(fn {_, _, r} -> r == result end)
  end
end
