defmodule Intcode.IO do
  alias Intcode.{Cpu, Memory}

  def execute_program(%Cpu{} = cpu, noun, verb) do
    cpu_with_input = %{cpu | memory: input_code(cpu.memory, noun, verb)}

    result =
      cpu_with_input
      |> Cpu.run()

    case Cpu.error?(result) do
      true -> :error
      false -> result.memory[0]
    end
  end

  def input_code(%Memory{} = state, a, b) do
    state |> Memory.poke(1, a) |> Memory.poke(2, b)
  end
end
