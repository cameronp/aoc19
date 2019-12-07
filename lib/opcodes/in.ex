defmodule Intcode.Opcodes.In do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, VmSocket}
  alias Intcode.IO, as: VIO

  def exec(%Cpu{input: [h | t]} = state, [{:ptr, p}]) do
    %{state | input: t}
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, h)
  end

  def exec(%Cpu{input: [], vm_socket_in: socket} = state, [{:ptr, p}]) when not is_nil(socket) do
    val = VmSocket.read(socket)

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, val)
  end

  def exec(%Cpu{input: []} = state, [{:ptr, p}]) do
    val = VIO.input()

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.poke(p, val)
  end

  def name(), do: "in"

  def arity(), do: 1

  def value, do: 3
end
