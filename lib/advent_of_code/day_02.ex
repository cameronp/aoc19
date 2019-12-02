defmodule AdventOfCode.Day02 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    input
    |> Memory.load()
    |> execute_program(12, 2)
  end

  def part2(input) do
    input
    |> Memory.load()
    |> find_result(19_690_720)
  end

  def find_result(%Memory{} = state, result) do
    for(n <- 0..255, v <- 0..255, do: {n, v, execute_program(state, n, v)})
    |> Enum.find(fn {_, _, r} -> r == result end)
  end

  def execute_program(%Memory{} = state, noun, verb) do
    result =
      state
      |> input_code(noun, verb)
      |> Cpu.boot()
      |> Cpu.run()

    case Cpu.error?(result) do
      true -> :error
      false -> result.memory[0]
    end
  end

  def input_code(%Memory{} = state, a, b) do
    state |> Memory.poke(1, a) |> Memory.poke(2, b)
  end
end
