defmodule Intcode.Opcodes.In do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, IO, Memory}

  def exec(%Cpu{input: []} = state, [{:ptr, p}]) do
    val = IO.input()

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, val)
  end

  def exec(%Cpu{input: [h | t]} = state, [{:ptr, p}]) do
    %{state | input: t}
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, h)
  end

  def name(), do: "in"

  def arity(), do: 1

  def value, do: 3
end
