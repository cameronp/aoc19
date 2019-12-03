defmodule Intcode.Cpu do
  alias Intcode.{Cpu, Memory, OpCode}
  defstruct memory: nil, ip: 0, opcodes: %{}

  @spec boot(Intcode.Memory.t()) :: Intcode.Cpu.t()
  @doc """
  Given a `Memory` with an Intcode program loaded, returns a ready to run `Cpu`
  """
  def boot(%Memory{} = mem), do: %Cpu{memory: mem, ip: 0, opcodes: OpCode.load_opcodes()}

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

  def run(%Cpu{memory: memory, ip: ip} = state) do
    instruction = memory[ip]
    new_state = exec(state, instruction)
    run(new_state)
  end

  defp exec(%Cpu{} = state, instruction) when is_integer(instruction) do
    {_, fun} = state.opcodes[instruction]
    fun.(state)
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
end
