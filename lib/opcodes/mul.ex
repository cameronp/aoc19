defmodule Intcode.Opcodes.Mul do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, Memory}

  def exec(%Cpu{ip: ip, memory: memory} = state) do
    op1 = memory[ip + 1]
    op2 = memory[ip + 2]
    result = memory[ip + 3]

    if op1 > memory[:size] || op2 > memory[:size] || result > memory[:size] do
      Cpu.error(state)
    else
      %{
        state
        | ip: ip + 4,
          memory: state.memory |> Memory.poke(result, memory[op1] * memory[op2])
      }
    end
  end

  def value(), do: 2

  def name(), do: "mul"

  def arity(), do: 2
end
