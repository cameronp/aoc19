defmodule AdventOfCode.Day03 do
  import Utils, only: [lines: 2]

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
    |> Enum.map(&compute_travel_time/1)
    |> Enum.sort()
    |> hd()
  end

  # Travel time is the sum of all segments up to the final segment, plus the remainder
  # of the final segments, which is the distance between the x and y coordinates of the two
  # segments. dh and dv are the accumulated distances of the preceding segments, which were
  # computed by `vectors`
  defp compute_travel_time({_, {:horz, dh, {xh, yh}, _}, {:vert, dv, {xv, yv}, _}}) do
    dh + dv + abs(xh - xv) + abs(yv - yh)
  end

  # no way to know whether the vertical segment comes first or second.
  defp compute_travel_time({_, {:vert, dv, {xv, yv}, _}, {:horz, dh, {xh, yh}, _}}) do
    dh + dv + abs(xh - xv) + abs(yv - yh)
  end

  defp load(input) do
    [wire1, wire2] = lines(input, &parse/1)
    {wire1, wire2}
  end

  defp parse(line) do
    String.split(line, ",", trim: true)
    |> Enum.map(&parse_el/1)
  end

  defp parse_el(el) do
    dir = String.slice(el, 0, 1)
    len = String.slice(el, 1..-1) |> String.to_integer()
    {dir, len}
  end

  # Computes all the segments resulting from a series of moves. returns a list of segments of the form:
  # {:horz | :vert, <cumulative steps before this segment>, <start point>, <end point>}
  defp vectors(moves), do: vectors(moves, {0, 0}, [], 0)

  defp vectors([{_, dist} = cmd | rest], current, results, cum_distance) do
    {type, next} = move(current, cmd)
    vectors(rest, next, [{type, cum_distance, current, next} | results], cum_distance + dist)
  end

  defp vectors([], _, results, _), do: results

  defp move({x, y}, {"U", len}), do: {:vert, {x, y + len}}
  defp move({x, y}, {"D", len}), do: {:vert, {x, y - len}}
  defp move({x, y}, {"L", len}), do: {:horz, {x - len, y}}
  defp move({x, y}, {"R", len}), do: {:horz, {x + len, y}}

  # returns true if two horizontal/vertical vectors intersect, false otherwise
  defp intersect?({:horz, _, _, _}, {:horz, _, _, _}), do: false
  defp intersect?({:vert, _, _, _}, {:vert, _, _, _}), do: false

  defp intersect?({:horz, _, {xh, yh}, {xh1, yh}}, {:vert, _, {xv, yv}, {xv, yv1}}) do
    min(xh, xh1) <= xv && max(xh, xh1) >= xv && min(yv, yv1) <= yh && max(yv, yv1) >= yh
  end

  defp intersect?({:vert, _, _, _} = a, {:horz, _, _, _} = b), do: intersect?(b, a)

  # returns the point at which a horizontal and vertical segment intersect
  defp intersection_point({:horz, _, {_, y}, _}, {:vert, _, {x, _}, _}), do: {x, y}

  defp intersection_point({:vert, _, _, _} = a, {:horz, _, _, _} = b),
    do: intersection_point(b, a)

  # returns a list of the intersections of the segments in two lists of segments
  defp intersections(lines1, lines2) when is_list(lines1) do
    Enum.reduce(lines1, [], fn l, acc -> acc ++ intersections(l, lines2) end)
  end

  # returns a list of the intersections of a segment with the segments in a list
  defp intersections(line, lines) do
    Enum.reduce(lines, [], fn l, acc ->
      if intersect?(l, line) do
        [{intersection_point(l, line), l, line} | acc]
      else
        acc
      end
    end)
  end

  # returns the manhattan distance from a point to the origin.
  defp manhattan_distance({x, y}), do: abs(x) + abs(y)
end
