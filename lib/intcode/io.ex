defmodule Intcode.IO do
  alias Intcode.{Cpu, Memory}

  def run(%Cpu{} = cpu) do
    result =
      cpu
      |> Cpu.run()

    case Cpu.error?(result) do
      true -> :error
      false -> output_code(result)
    end
  end

  @spec run(Intcode.Cpu.t(), Integer.t(), Integer.t()) :: Integer.t()
  def run(%Cpu{} = cpu, noun, verb) do
    cpu
    |> input_code(noun, verb)
    |> run
  end

  defp input_code(%Cpu{} = state, a, b) do
    new_memory = state.memory |> Memory.poke(1, a) |> Memory.poke(2, b)
    %{state | memory: new_memory}
  end

  defp output_code(%Cpu{memory: memory}), do: memory[0]
end
