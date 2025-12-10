defmodule MovieTheater do
  def compute do
    parse_file()
    |> find_biggest_rectangle(0)
  end

  def parse_file do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(fn [x, y] ->
      %{x: String.to_integer(x), y: String.to_integer(y)}
    end)
    |> Enum.sort(fn point_1, point_2 -> point_1.x + point_1.y < point_2.x + point_2.y end)
  end

  def find_biggest_rectangle([], max_area), do: max_area

  def find_biggest_rectangle([point | points], max_area) do
    find_biggest_rectangle(
      points,
      Enum.reduce(points, max_area, fn tmp_point, tmp_max_area ->
        area = area(tmp_point, point)

        if area > tmp_max_area do
          IO.puts(
            "New max area #{area} found between #{inspect(tmp_point)} and #{inspect(point)}!"
          )

          area
        else
          tmp_max_area
        end
      end)
    )
  end

  defp area(point_1, point_2) do
    (abs(point_1.x - point_2.x) + 1) * (abs(point_1.y - point_2.y) + 1)
  end
end

IO.inspect(MovieTheater.compute())
