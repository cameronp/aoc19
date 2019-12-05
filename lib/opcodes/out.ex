defmodule Intcode.Opcodes.Out do
  @behaviour Intcode.OpCode
  alias Intcode.{Cpu, IO}
  import Intcode.OpCode, only: [val: 2]

  def exec(%Cpu{ip: ip, memory: memory} = state, a) do
    IO.output(val(a, memory))

    %{
      state
      | ip: ip + 2
    }
  end

  def name(), do: "out"

  def arity(), do: 1

  def value, do: 4
end
