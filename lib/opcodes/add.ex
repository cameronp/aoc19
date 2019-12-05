defmodule Intcode.Opcodes.Add do
  @behaviour Intcode.OpCode
  alias Intcode.Cpu

  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory} = state, [a, b, {:ptr, p}]) do
    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, val(a, memory) + val(b, memory))
  end

  def name(), do: "add"

  def arity(), do: 3

  def value, do: 1
end
