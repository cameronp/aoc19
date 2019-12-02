defmodule Intcode.Memory do
  @moduledoc """
  Implements memory for the Intcode computer.
  """
  @behaviour Access
  import Utils, only: [csv: 2]

  alias Intcode.Memory

  defstruct size: 0, error: false, memory: %{}

  def load(input) do
    input
    |> csv(&String.to_integer/1)
    |> to_map()
  end

  def to_map(ints) do
    memory =
      ints
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    size = Enum.count(ints) - 1
    %Memory{size: size, memory: memory}
  end

  def to_list(%Memory{} = memory) do
    memory.memory
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn k -> memory.memory[k] end)
  end

  def poke(%Memory{memory: memory_internal, size: size} = mem, addr, val)
      when is_integer(addr) and addr <= size,
      do: %{mem | memory: %{memory_internal | addr => val}}

  def succeed(%Memory{} = mem), do: %{mem | error: false}

  def fail(%Memory{} = mem), do: %{mem | error: true}

  def fetch(%Memory{size: size}, :size), do: {:ok, size}

  def fetch(%Memory{error: error}, :error), do: {:ok, error}

  def fetch(%Memory{size: size}, address) when is_integer(address) and address > size,
    do: :error

  def fetch(%Memory{memory: memory}, address) when is_integer(address), do: {:ok, memory[address]}

  def fetch(_, _), do: :error

  def get_and_update(
        %Memory{size: size, error: error, memory: memory_internal} = memory,
        key,
        fun
      ) do
    IO.inspect(key)

    case key do
      :size ->
        # I'm not going to let you change the memory size.
        _ = fun.(size)
        {size, memory}

      :error ->
        # I'm also not going to let you change error state.
        _ = fun.(error)

      addr when is_integer(addr) ->
        case fun.(memory_internal[addr]) do
          # you also can't "pop" memory addresses.
          :pop ->
            {memory_internal[addr], memory}

          {get_value, new_value} ->
            {get_value, %{memory | memory: %{memory_internal | addr => new_value}}}
        end
    end
  end

  # no popping allowed.
  def pop(%Memory{} = mem, key), do: {fetch(mem, key), mem}
end
