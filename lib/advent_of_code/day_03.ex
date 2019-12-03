defmodule AdventOfCode.Day03 do
  import Utils

  def part1(input) do
    {wire1, wire2} = load(input)
    lines1 = vectors(wire1)
    lines2 = vectors(wire2)

    intersections(lines1, lines2)
    |> Enum.map(fn {point, _, _} -> manhattan_distance(point) end)
    |> Enum.sort()
    |> Enum.drop_while(fn d -> d == 0 end)
    |> hd()
  end

  def part2(input) do
    {wire1, wire2} = load(input)
    lines1 = vectors(wire1)
    lines2 = vectors(wire2)

    intersections(lines1, lines2)
    # |> Enum.sort_by(fn {_, {_, d1, _, _}, {_, d2, _, _}} -> d1 + d2 end)
    |> Enum.map(&compute_travel_time/1)
    |> Enum.sort()
    |> hd()
  end

  def compute_travel_time({_, {:horz, dh, {xh, yh}, _}, {:vert, dv, {xv, yv}, _}}) do
    dh + dv + abs(xh - xv) + abs(yv - yh)
  end

  def compute_travel_time({_, {:vert, dv, {xv, yv}, _}, {:horz, dh, {xh, yh}, _}}) do
    dh + dv + abs(xh - xv) + abs(yv - yh)
  end

  def load(input) do
    [wire1, wire2] = lines(input, &parse/1)
    {wire1, wire2}
  end

  def parse(line) do
    String.split(line, ",", trim: true)
    |> Enum.map(&parse_el/1)
  end

  def parse_el(el) do
    dir = String.slice(el, 0, 1)
    len = String.slice(el, 1..-1) |> String.to_integer()
    {dir, len}
  end

  def vectors(moves), do: vectors(moves, {0, 0}, [], 0)

  def vectors([{_, dist} = cmd | rest], current, results, cum_distance) do
    {type, next} = move(current, cmd)
    vectors(rest, next, [{type, cum_distance, current, next} | results], cum_distance + dist)
  end

  def vectors([], _, results, _), do: results

  def move({x, y}, {"U", len}), do: {:vert, {x, y + len}}
  def move({x, y}, {"D", len}), do: {:vert, {x, y - len}}
  def move({x, y}, {"L", len}), do: {:horz, {x - len, y}}
  def move({x, y}, {"R", len}), do: {:horz, {x + len, y}}

  def intersect?({:horz, _, _, _}, {:horz, _, _, _}), do: false
  def intersect?({:vert, _, _, _}, {:vert, _, _, _}), do: false

  def intersect?({:horz, _, {xh, yh}, {xh1, yh}}, {:vert, _, {xv, yv}, {xv, yv1}}) do
    min(xh, xh1) <= xv && max(xh, xh1) >= xv && min(yv, yv1) <= yh && max(yv, yv1) >= yh
  end

  def intersect?({:vert, _, _, _} = a, {:horz, _, _, _} = b), do: intersect?(b, a)

  def intersection_point({:horz, _, {_, y}, _}, {:vert, _, {x, _}, _}), do: {x, y}
  def intersection_point({:vert, _, _, _} = a, {:horz, _, _, _} = b), do: intersection_point(b, a)

  def intersections(lines1, lines2) when is_list(lines1) do
    Enum.reduce(lines1, [], fn l, acc -> acc ++ intersections(l, lines2) end)
  end

  def intersections(line, lines) do
    Enum.reduce(lines, [], fn l, acc ->
      if intersect?(l, line) do
        [{intersection_point(l, line), l, line} | acc]
      else
        acc
      end
    end)
  end

  def manhattan_distance({x, y}), do: abs(x) + abs(y)
end
