defmodule Intcode.Opcodes.Eq do
  @behaviour Intcode.OpCode
  alias Intcode.Cpu

  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory} = state, [a, b, {:ptr, p}]) do
    flag =
      case val(a, memory) == val(b, memory) do
        true -> 1
        false -> 0
      end

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, flag)
  end

  def name(), do: "eq"

  def arity(), do: 3

  def value, do: 8
end
