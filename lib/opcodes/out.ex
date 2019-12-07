defmodule Intcode.Opcodes.Out do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, VmSocket}
  alias Intcode.IO, as: VIO
  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{memory: memory, vm_socket_out: socket} = state, [a]) when not is_nil(socket) do
    val = val(a, memory)

    VmSocket.write(socket, val)

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.record_output(val(a, memory))
  end

  def exec(%Cpu{memory: memory} = state, [a]) do
    if !state.silent? do
      VIO.output(val(a, memory))
    end

    state
    |> Cpu.inc_ip(arity() + 1)
    |> Cpu.record_output(val(a, memory))
  end

  def name(), do: "out"

  def arity(), do: 1

  def value, do: 4
end
