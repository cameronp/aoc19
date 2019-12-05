defmodule Intcode.Opcodes.Jt do
  @behaviour Intcode.OpCode
  alias Intcode.Cpu

  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory} = state, [a, dest]) do
    p = val(dest, memory)

    case val(a, memory) do
      0 -> state |> Cpu.inc_ip(arity() + 1)
      _ -> state |> Cpu.set_ip(p)
    end
  end

  def name(), do: "jt"

  def arity(), do: 2

  def value, do: 5
end
