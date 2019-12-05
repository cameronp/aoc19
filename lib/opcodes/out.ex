defmodule Intcode.Opcodes.Out do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, IO}
  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory} = state, [a]) do
    if !state.silent? do
      IO.output(val(a, memory))
    end

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.record_output(val(a, memory))
  end

  def name(), do: "out"

  def arity(), do: 1

  def value, do: 4
end
