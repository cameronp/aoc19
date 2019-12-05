defmodule Intcode.Opcodes.Jf do
  @behaviour Intcode.OpCode
  alias Intcode.Cpu

  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory} = state, [a, dest]) do
    p = val(dest, memory)

    case val(a, memory) do
      0 -> state |> Cpu.set_ip(p)
      _ -> state |> Cpu.inc_ip(arity() + 1)
    end
  end

  def name(), do: "jf"

  def arity(), do: 2

  def value, do: 6
end
