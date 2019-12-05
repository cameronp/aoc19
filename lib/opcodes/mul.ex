defmodule Intcode.Opcodes.Mul do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, Memory}
  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{ip: ip, memory: memory} = state, [a, b, {:ptr, p}]) do
    %{
      state
      | ip: ip + 4,
        memory: state.memory |> Memory.poke(p, val(a, memory) * val(b, memory))
    }
  end

  def value(), do: 2

  def name(), do: "mul"

  def arity(), do: 3
end
