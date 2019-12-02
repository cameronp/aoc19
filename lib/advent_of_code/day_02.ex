defmodule AdventOfCode.Day02 do
  import Utils
  alias Intcode.Memory

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
      |> run(0)

    case result do
      %Memory{error: true} -> :error
      %Memory{error: false} = state -> state[0]
    end
  end

  def input_code(%Memory{} = state, a, b) do
    state |> Memory.poke(1, a) |> Memory.poke(2, b)
  end

  def run(%Memory{} = state, :halt), do: state |> Memory.succeed()

  def run(%Memory{} = state, :error), do: Memory.fail(state)

  def run(%Memory{} = state, ip) do
    instruction = state[ip]
    {new_ip, new_state} = exec(state, ip, instruction)
    run(new_state, new_ip)
  end

  def exec(%Memory{} = state, ip, 1) do
    op1 = state[ip + 1]
    op2 = state[ip + 2]
    result = state[ip + 3]

    if op1 > state[:size] || op2 > state[:size] || result > state[:size] do
      error(state)
    else
      new_state = state |> Memory.poke(result, state[op1] + state[op2])
      {ip + 4, new_state}
    end
  end

  def exec(%Memory{} = state, ip, 2) do
    op1 = state[ip + 1]
    op2 = state[ip + 2]
    result = state[ip + 3]

    if op1 > state[:size] || op2 > state[:size] || result > state[:size] do
      error(state)
    else
      new_state = state |> Memory.poke(result, state[op1] * state[op2])

      {ip + 4, new_state}
    end
  end

  def exec(%Memory{} = state, _ip, 99) do
    {:halt, state}
  end

  def error(state), do: {:error, state}
end
