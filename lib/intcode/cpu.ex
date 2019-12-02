defmodule Intcode.Cpu do
  alias Intcode.{Cpu, Memory}
  defstruct memory: nil, ip: 0

  def boot(%Memory{} = mem), do: %Cpu{memory: mem, ip: 0}

  def error?(%Cpu{memory: %{error: true}}), do: true
  def error?(%Cpu{}), do: false

  def run(%Cpu{ip: :halt} = state), do: %Cpu{state | memory: Memory.succeed(state.memory)}
  def run(%Cpu{ip: :error} = state), do: %Cpu{state | memory: Memory.fail(state.memory)}

  def run(%Cpu{memory: memory, ip: ip} = state) do
    instruction = memory[ip]
    new_state = exec(state, instruction)
    run(new_state)
  end

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
