defmodule Intcode.OpCode do
  alias Intcode.{Cpu}
  @callback exec(Cpu.t()) :: Cpu.t()
  @callback name() :: binary
  @callback value() :: integer
  @callback arity() :: integer
end
