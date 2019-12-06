defmodule AdventOfCode.Day06 do
  import Utils, only: [lines: 2]

  def part1(input) do
    tree = load(input)

    tree |> reduce_tree(0, &sum/2)
  end

  def part2(input) do
    tree = load(input)

    you =
      tree
      |> path("YOU")
      |> Enum.map(fn {loc, _, _} -> loc end)

    san =
      tree
      |> path("SAN")
      |> Enum.map(fn {loc, _, _} -> loc end)

    {you_path, san_path} = common(you, san)
    Enum.count(you_path) + Enum.count(san_path) - 2
  end

  def load(input) do
    input
    |> lines(&parse/1)
    |> build_map()
    |> build_tree("COM")
    |> measure_depth(0)
  end

  def common([_, a | t1], [_, b | t2]) when not (a == b), do: {[a | t1], [b | t2]}
  def common([_ | t1], [_ | t2]), do: common(t1, t2)

  def parse(instruction) do
    [object, subject] = instruction |> String.split(")")
    {:orbits, subject, object}
  end

  def build_map(cmds), do: build_map(cmds, %{})

  def build_map([], map), do: map

  def build_map([{:orbits, subject, object} | t], map) do
    entry = map[object] || []
    new_map = Map.put(map, object, [subject | entry])
    build_map(t, new_map)
  end

  def build_tree(map, root) do
    children = map[root] || []
    {root, Enum.map(children, fn c -> build_tree(map, c) end)}
  end

  def measure_depth({loc, []}, depth), do: {loc, [], depth}

  def measure_depth({loc, children}, depth) do
    subtrees =
      children
      |> Enum.map(fn c -> measure_depth(c, depth + 1) end)

    {loc, subtrees, depth}
  end

  def reduce_tree({_, [], _} = node, acc, fun) do
    fun.(node, acc)
  end

  def reduce_tree({_, children, _} = node, acc, fun) do
    new_acc = Enum.reduce(children, acc, fn c, acc -> reduce_tree(c, acc, fun) end)
    fun.(node, new_acc)
  end

  def sum({_, _, val}, acc), do: acc + val

  def contains?({loc, _, _}, loc), do: true
  def contains?({not_loc, [], _}, loc) when not (loc == not_loc), do: false

  def contains?({not_loc, children, _}, loc) when not (loc == not_loc),
    do: Enum.any?(children, fn c -> contains?(c, loc) end)

  def path(tree, target), do: path(tree, target, [])

  def path({target, _, _} = node, target, path), do: [node | path] |> Enum.reverse()

  def path({non_target, [], _}, target, _path) when not (target == non_target),
    do: :not_found

  def path({non_target, children, _} = node, target, path) when not (target == non_target) do
    children
    |> Enum.map(fn c -> path(c, target, [node | path]) end)
    |> Enum.find(:not_found, fn p -> p != :not_found end)
  end
end
