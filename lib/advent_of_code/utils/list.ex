defmodule Utils.List do
  @doc """
  Returns `true` if a list contains at least two adjacent elements which are equal,
  `false` otherwise
  """
  @spec has_doubled_elements?(maybe_improper_list) :: boolean
  def has_doubled_elements?([]), do: false
  def has_doubled_elements?([_]), do: false
  def has_doubled_elements?([a, a | _]), do: true
  def has_doubled_elements?([_ | t]), do: has_doubled_elements?(t)

  @doc """
  Returns `true` if a list contains at least one pair of adjacent elements that are equal
  but are not part of a series of adjacent elements with the same value.

  """
  @spec has_isolated_double?(maybe_improper_list) :: boolean
  def has_isolated_double?([]), do: false
  def has_isolated_double?([_]), do: false

  def has_isolated_double?([a, a | t]) do
    case t do
      [^a | _] -> skip(t, a) |> has_isolated_double?()
      _ -> true
    end
  end

  def has_isolated_double?([_ | t]), do: has_isolated_double?(t)
  @spec is_sorted?(any) :: boolean
  def is_sorted?(list), do: list == Enum.sort(list)

  @doc """
  Given a list, and a value, removes any elements at the beginning of the list equal to
  the value.
  """
  @spec skip(maybe_improper_list, any) :: maybe_improper_list
  def skip([], _val), do: []
  def skip([val1 | _] = list, val) when not (val == val1), do: list
  def skip([_ | t], val), do: skip(t, val)
end
