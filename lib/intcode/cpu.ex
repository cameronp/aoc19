defmodule Intcode.Cpu do
  alias Intcode.{Cpu, Memory, OpCode}
  defstruct memory: nil, ip: 0, opcode_modules: %{}, output: [], input: [], silent?: false

  @spec boot(Intcode.Memory.t()) :: Intcode.Cpu.t()
  @doc """
  Given a `Memory` with an Intcode program loaded, returns a ready to run `Cpu`
  """
  def boot(%Memory{} = mem),
    do: %Cpu{memory: mem, ip: 0, opcode_modules: OpCode.load_opcode_modules()}

  @doc """
  Returns true if the given `Cpu` is in an error state.
  """
  @spec error?(Intcode.Cpu.t()) :: boolean
  def error?(%Cpu{memory: %{error: true}}), do: true
  def error?(%Cpu{}), do: false

  @doc """
  Runs the program in memory, starting from wherever the IP address is located stopping
  in the event of a halt opcode, or an error.
  """
  @spec run(Intcode.Cpu.t()) :: Intcode.Cpu.t()
  def run(%Cpu{ip: :halt} = state), do: %Cpu{state | memory: Memory.succeed(state.memory)}
  def run(%Cpu{ip: :error} = state), do: %Cpu{state | memory: Memory.fail(state.memory)}

  def run(%Cpu{memory: memory, ip: ip, opcode_modules: opcode_modules} = state) do
    {instruction, parm_types} = memory[ip] |> OpCode.parse_opcode(opcode_modules)
    raw_parms = Memory.to_list(memory, ip + 1, Enum.count(parm_types))
    parms = OpCode.parse_parms(parm_types, raw_parms)
    new_state = exec(state, {instruction, parms})
    run(new_state)
  end

  defp exec(%Cpu{} = state, {instruction, parms})
       when is_integer(instruction) and is_list(parms) do
    {_, fun, _} = state.opcode_modules[instruction]
    fun.(state, parms)
  end

  @doc """
  Returns a list containing a memory dump.
  """
  @spec dump(Intcode.Cpu.t()) :: [Integer.t()]
  def dump(%Cpu{memory: memory}), do: Memory.to_list(memory)

  @spec error(Intcode.Cpu.t()) :: Intcode.Cpu.t()
  def error(%Cpu{} = state) do
    %{state | ip: :error}
  end

  def inc_ip(%Cpu{ip: ip} = state, inc), do: %{state | ip: ip + inc}

  def set_ip(%Cpu{} = state, new_ip), do: %{state | ip: new_ip}

  def poke(%Cpu{memory: memory} = state, addr, val),
    do: %{state | memory: memory |> Memory.poke(addr, val)}

  def record_output(%Cpu{output: output} = state, i), do: %{state | output: [i | output]}

  def preload_input(%Cpu{} = state, input), do: %{state | input: input, silent?: true}
end
