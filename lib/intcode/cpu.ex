defmodule Intcode.Cpu do
  alias Intcode.{Cpu, Memory}
  defstruct memory: nil, ip: 0

  @spec boot(Intcode.Memory.t()) :: Intcode.Cpu.t()
  @doc """
  Given a `Memory` with an Intcode program loaded, returns a ready to run `Cpu`
  """
  def boot(%Memory{} = mem), do: %Cpu{memory: mem, ip: 0}

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

  @doc """
  Returns a list containing a memory dump.
  """
  @spec dump(Intcode.Cpu.t()) :: [Integer.t()]
  def dump(%Cpu{memory: memory}), do: Memory.to_list(memory)

  defp exec(%Cpu{ip: ip, memory: memory} = state, 1) do
    op1 = memory[ip + 1]
    op2 = memory[ip + 2]
    result = memory[ip + 3]

    if op1 > memory[:size] || op2 > memory[:size] || result > memory[:size] do
      error(state)
    else
      %{
        state
        | ip: ip + 4,
          memory: state.memory |> Memory.poke(result, memory[op1] + memory[op2])
      }
    end
  end

  defp exec(%Cpu{ip: ip, memory: memory} = state, 2) do
    op1 = memory[ip + 1]
    op2 = memory[ip + 2]
    result = memory[ip + 3]

    if op1 > memory[:size] || op2 > memory[:size] || result > memory[:size] do
      error(state)
    else
      %{
        state
        | ip: ip + 4,
          memory: state.memory |> Memory.poke(result, memory[op1] * memory[op2])
      }
    end
  end

  defp exec(%Cpu{} = state, 99) do
    %{state | ip: :halt}
  end

  defp error(%Cpu{} = state) do
    %{state | ip: :error}
  end
end
