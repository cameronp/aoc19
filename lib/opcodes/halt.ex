defmodule Intcode.Opcodes.Halt do
  @behaviour Intcode.OpCode
  alias Intcode.Cpu

  def exec(%Cpu{monitor: monitor} = state, []) when is_pid(monitor) do
    send(monitor, {:halt, state.output})
    %{state | ip: :halt}
  end

  def exec(%Cpu{} = state, []) do
    %{state | ip: :halt}
  end

  def name(), do: "halt"

  def value(), do: 99

  def arity(), do: 0
end
