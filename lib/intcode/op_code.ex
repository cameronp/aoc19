defmodule Intcode.OpCode do
  alias Intcode.{Cpu}
  @callback exec(Cpu.t()) :: Cpu.t()
  @callback name() :: binary
  @callback value() :: integer
  @callback arity() :: integer

  def load_opcodes() do
    opcode_modules =
      :application.get_key(:advent_of_code_2019, :modules)
      |> elem(1)
      |> Enum.filter(fn m -> Module.split(m) |> Enum.find(fn s -> s == "Opcodes" end) end)

    opcode_modules
    |> Enum.map(fn m -> {m.value, {m.name, &m.exec/1}} end)
    |> Enum.into(%{})
  end
end
