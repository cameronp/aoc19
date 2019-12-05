defmodule Intcode.IO do
  alias Intcode.{Cpu, Memory}

  @doc """
  Runs the given cpu, in its current state, until it errors or halts.
  Returns the "output" value, which is defined to be the value at address 0.
  """
  @spec run(Intcode.Cpu.t()) :: Integer.t()
  def run(%Cpu{} = cpu) do
    cpu
    |> Cpu.run()
  end

  @doc """
  Runs the given Cpu, but replaces the values at addresses 1 and 2 with the passed in `noun` and `verb`
  Returns the "output" value, which is defined to be the value at address 0.
  """
  @spec run(Intcode.Cpu.t(), Integer.t(), Integer.t()) :: Integer.t()
  def run(%Cpu{} = cpu, noun, verb) do
    result =
      cpu
      |> input_code(noun, verb)
      |> run

    case Cpu.error?(result) do
      true -> :error
      false -> output_code(result)
    end
  end

  def input(), do: IO.read(:line) |> String.trim() |> String.to_integer()

  def output(int), do: IO.puts(int)

  defp input_code(%Cpu{} = state, a, b) do
    new_memory = state.memory |> Memory.poke(1, a) |> Memory.poke(2, b)
    %{state | memory: new_memory}
  end

  defp output_code(%Cpu{memory: memory}), do: memory[0]
end
