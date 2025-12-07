defmodule Laboratories do
  def compute() do
    lines = parse_file()

    lines
    |> Enum.reverse()
    |> find_solution_from_bottom(nil)
  end

  def parse_file() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.map(&Enum.into(&1, %{}, fn {k, v} -> {v, k} end))
  end

  def find_solution_from_bottom([line | previous_lines], nil) do
    cache_line =
      line
      |> Enum.map(fn {k, _v} -> {k, 1} end)
      |> Enum.into(%{}, fn {k, v} -> {k, v} end)

    find_solution_from_bottom(previous_lines, cache_line)
  end

  def find_solution_from_bottom([line], cache) do
    {beam_position, _} = Enum.find(line, fn {_k, v} -> v == "S" end)
    Map.get(cache, beam_position)
  end

  def find_solution_from_bottom([line | previous_lines], cache) do
    cache_line =
      line
      |> Enum.map(fn
        {k, "."} ->
          {k, Map.get(cache, k)}

        {k, "^"} ->
          {k, Map.get(cache, k - 1) + Map.get(cache, k + 1)}
      end)
      |> Enum.into(%{}, fn {k, v} -> {k, v} end)

    find_solution_from_bottom(previous_lines, cache_line)
  end
end

IO.inspect(Laboratories.compute())
