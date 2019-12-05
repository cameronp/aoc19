defmodule Intcode.OpCode do
  alias Intcode.{Cpu, Memory}
  @callback exec(Cpu.t(), [{atom, integer}]) :: Cpu.t()
  @callback name() :: binary
  @callback value() :: integer
  @callback arity() :: integer

  defstruct id: 0, params: []

  def load_opcode_modules() do
    opcode_modules =
      :application.get_key(:advent_of_code_2019, :modules)
      |> elem(1)
      |> Enum.filter(fn m -> Module.split(m) |> Enum.find(fn s -> s == "Opcodes" end) end)

    opcode_modules
    |> Enum.map(fn m -> {m.value, {m.name, &m.exec/2, m}} end)
    |> Enum.into(%{})
  end

  def parse_opcode(code, opcode_modules) do
    id = rem(code, 100)

    parm_types =
      code
      |> div(100)
      |> Integer.digits()
      |> Enum.reverse()

    {_, _, module} = opcode_modules[id]
    arity = module.arity()

    parm_types =
      if arity > 0 do
        Utils.List.pad(parm_types, arity - Enum.count(parm_types), 0)
      else
        []
      end

    {id, parm_types}
  end

  def parse_parms([], _), do: []
  def parse_parms([0 | t], [ptr | mem_t]), do: [{:ptr, ptr} | parse_parms(t, mem_t)]
  def parse_parms([1 | t], [val | mem_t]), do: [{:val, val} | parse_parms(t, mem_t)]

  def val({:val, v}, _), do: v
  def val({:ptr, p}, %Memory{size: size} = memory) when size >= p, do: memory[p]
  def val({:ptr, _}, _), do: raise(RuntimeError, message: "Intcode error: bad memory pointer")
end
