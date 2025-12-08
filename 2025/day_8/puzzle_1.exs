defmodule Playground do
  def compute() do
    parse_file()
    |> find_closest()
    |> build_connections()
    |> Enum.sort_by(&MapSet.size/1, :desc)
    |> Enum.take(3)
    |> Enum.map(&MapSet.size/1)
    |> Enum.product()
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

  defp find_closest(positions) do
    Enum.reduce(positions, [], fn {i, position_1}, distances ->
      positions
      |> Enum.filter(fn {j, _} -> j > i end)
      |> Enum.reduce(distances, fn {j, position_2}, distances ->
        [{i, j, compute_distance(position_1, position_2)} | distances]
      end)
    end)
    |> Enum.sort(fn {_, _, d1}, {_, _, d2} -> d1 < d2 end)
    |> Enum.map(fn {i, j, _distance} -> MapSet.new([i, j]) end)
    |> Enum.take(1000)
  end

  defp compute_distance(position_1, position_2) do
    ((position_1.x - position_2.x) ** 2 + (position_1.y - position_2.y) ** 2 +
       (position_1.z - position_2.z) ** 2) ** 0.5
  end

  defp build_connections(current_connections) do
    Enum.reduce(current_connections, [], fn current_connection, new_connections ->
      case merge_connection(new_connections, current_connection) do
        {updated_connections, true} ->
          build_connections(updated_connections)

        {updated_connections, false} ->
          [current_connection | updated_connections]
      end
    end)
  end

  defp merge_connection(connections, new_connection) do
    Enum.reduce(connections, {[], false}, fn connection, {updated_connections, added?} ->
      if MapSet.disjoint?(connection, new_connection) do
        {[connection | updated_connections], added?}
      else
        {[MapSet.union(connection, new_connection) | updated_connections], true}
      end
    end)
  end
end

IO.inspect(Playground.compute())
