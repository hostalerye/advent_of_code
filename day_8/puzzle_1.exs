defmodule Playground do
  def compute() do
    positions = parse_file()
    distances = compute_distances(positions)
  end

  defp parse_file() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [x, y, z] = String.split(line, ",", trim: true)
      %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
    end)
    |> Enum.with_index()
    |> Enum.into(%{}, fn {k, v} -> {v, k} end)
  end

  defp compute_distances(positions) do
    positions_count = Enum.count(positions)

    Enum.reduce(positions, %{}, fn {i, position_1}, distances ->
      Enum.reduce(positions, distances, fn {j, position_2}, distances ->
        Map.put(distances, "#{i}-#{j}", compute_distance(position_1, position_2))
      end)
    end)
  end

  defp compute_distance(position_1, position_2) do
    ((position_1.x - position_2.x)**2 + (position_1.y - position_2.y)**2 + (position_1.z - position_2.z)**2) ** 0.5
  end
end

IO.inspect(Playground.compute())
