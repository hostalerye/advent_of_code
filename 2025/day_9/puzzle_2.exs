defmodule MovieTheater do
  def compute do
    points = parse_file()
    lines = draw_lines(points)
    combinaisons = combinations(points)
    points_set = MapSet.new(points)

    IO.puts("#{Enum.count(points)} points")
    IO.puts("#{Enum.count(combinaisons)} combinaisons")
    IO.puts("#{Enum.count(lines)} lines")
    find_biggest_rectangle(combinaisons, lines, points_set)
  end

  defp parse_file do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [x, y] = String.split(line, ",", trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  defp combinations([]), do: []

  defp combinaisons([h | t]) do
    Enum.map(t, fn point ->
      [h, point]
    end) ++ combinaisons(t)
  end

  defp draw_lines(points), do: draw_lines_rec(points, [[List.last(points), List.first(points)]])

  defp draw_lines_rec([point_1, point_2 | points], lines),
    do: draw_lines_rec([point_2 | points], [[point_1, point_2] | lines])

  defp draw_lines_rec([_], lines), do: lines

  defp find_biggest_rectangle(combinaisons, lines, points_set) do
    combinaisons_by_area =
      combinaisons
      |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
        [{x1, y1}, {x2, y2}, area(min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2))]
      end)
      |> Enum.sort_by(fn [_, _, area] -> area end, :desc)

    Enum.find(combinaisons_by_area, fn [{x1, y1}, {x2, y2}, area] ->
      min_x = min(x1, x2)
      min_y = min(y1, y2)
      max_x = max(x1, x2)
      max_y = max(y1, y2)

      is_valid_rectangle?(
        min_x,
        max_x,
        min_y,
        max_y,
        lines,
        points_set
      )
    end)
  end

  defp is_valid_rectangle?(min_x, max_x, min_y, max_y, lines, points_set) do
    corners = [
      {min_x, min_y},
      {max_x, min_y},
      {max_x, max_y},
      {min_x, max_y}
    ]

    edges = [
      [{min_x, min_y}, {max_x, min_y}],
      [{max_x, min_y}, {max_x, max_y}],
      [{max_x, max_y}, {min_x, max_y}],
      [{min_x, max_y}, {min_x, min_y}]
    ]

    Enum.all?(corners, fn corner ->
      is_valid_point?(corner, lines, points_set)
    end) &&
      Enum.all?(edges, fn edge ->
        is_valid_line?(edge, lines, points_set)
      end)
  end

  defp is_valid_line?([{line_x1, line_y1}, {line_x2, line_y2}], lines, points_set)
       when line_x1 == line_x2 do
    Enum.all?((min(line_y1, line_y2) + 1)..(max(line_y1, line_y2) - 1)//1, fn y ->
      is_valid_point?({line_x1, y}, lines, points_set)
    end)
  end

  defp is_valid_line?([{line_x1, line_y1}, {line_x2, line_y2}], lines, points_set)
       when line_y1 == line_y2 do
    Enum.all?((min(line_x1, line_x2) + 1)..(max(line_x1, line_x2) - 1)//1, fn x ->
      is_valid_point?({x, line_y1}, lines, points_set)
    end)
  end

  defp is_valid_point?(point, lines, points_set) do
    MapSet.member?(points_set, point) || rem(intersections_with_lines(point, lines), 2) == 1
  end

  defp intersections_with_lines({x, y}, lines) do
    Enum.reduce_while(lines, 0, fn [{line_x1, line_y1}, {line_x2, line_y2}], acc ->
      cond do
        # Check if point is on the line (vertical)
        line_x1 == line_x2 && x == line_x1 && y >= min(line_y1, line_y2) &&
            y <= max(line_y1, line_y2) ->
          {:halt, 1}

        # Check if point is on the line (horizontal)
        line_y1 == line_y2 && y == line_y1 && x >= min(line_x1, line_x2) &&
            x <= max(line_x1, line_x2) ->
          {:halt, 1}

        # Chek if point intersects with a vertical line.
        # We exclude the max y point to avoid counting the same intersection twice.
        line_x1 == line_x2 && x < line_x1 && y >= min(line_y1, line_y2) &&
            y < max(line_y1, line_y2) ->
          {:cont, acc + 1}

        true ->
          {:cont, acc}
      end
    end)
  end

  defp area(min_x, max_x, min_y, max_y) do
    (max_x - min_x + 1) * (max_y - min_y + 1)
  end
end

IO.inspect(MovieTheater.compute())
