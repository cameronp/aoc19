defmodule Intcode.Memory do
  @moduledoc """
  Implements memory for the Intcode computer.
  """
  @behaviour Access
  import Utils, only: [csv: 2]

  alias Intcode.Memory

  defstruct size: 0, error: false, memory: %{}

  @spec load(binary) :: Intcode.Memory.t()
  def load(input) do
    input
    |> csv(&String.to_integer/1)
    |> to_map()
  end

  @spec to_map([integer]) :: Intcode.Memory.t()
  def to_map(ints) do
    memory =
      ints
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})

    size = Enum.count(ints) - 1
    %Memory{size: size, memory: memory}
  end

  @spec to_list(Intcode.Memory.t()) :: [integer]
  def to_list(%Memory{} = memory) do
    memory.memory
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn k -> memory.memory[k] end)
  end

  @spec poke(Memory.t(), integer, integer) :: Memory.t()
  def poke(%Memory{memory: memory_internal, size: size} = mem, addr, val)
      when is_integer(addr) and addr <= size,
      do: %{mem | memory: %{memory_internal | addr => val}}

  @spec succeed(Memory.t()) :: Memory.t()
  def succeed(%Memory{} = mem), do: %{mem | error: false}

  @spec fail(Memory.t()) :: Memory.t()
  def fail(%Memory{} = mem), do: %{mem | error: true}

  @spec fetch(Memory.t(), :size) :: {:ok, integer}
  def fetch(%Memory{size: size}, :size), do: {:ok, size}

  @spec fetch(Memory.t(), :error) :: {:ok, boolean}
  def fetch(%Memory{error: error}, :error), do: {:ok, error}

  @spec fetch(Memory.t(), integer) :: :error
  def fetch(%Memory{size: size}, address) when is_integer(address) and address > size,
    do: :error

  @spec fetch(Memory.t(), integer) :: {:ok, integer}
  def fetch(%Memory{memory: memory}, address) when is_integer(address), do: {:ok, memory[address]}

  def fetch(_, _), do: :error

  @spec get_and_update(Intcode.Memory.t(), :error | :size | integer, (Integer.t() -> any)) ::
          {boolean | Integer.t(), Memory.t()}
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
        {error, memory}

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
  @spec pop(Intcode.Memory.t(), Integer.t() | Atom.t()) ::
          {:error | {:ok, Integer.t()}, Intcode.Memory.t()}
  def pop(%Memory{} = mem, key), do: {fetch(mem, key), mem}
end
