defmodule Intcode.Opcodes.In do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, IO, Memory}

  def exec(%Cpu{ip: ip, memory: memory} = state, [:ptr, p]) do
    val = IO.input()

    %{
      state
      | ip: ip + 2,
        memory: memory |> Memory.poke(p, val)
    }
  end

  def name(), do: "in"

  def arity(), do: 1

  def value, do: 3
end
