defmodule PaperRolls do
  def compute do
    parse_input_file()
    |> find_accessible_rolls()
  end

  def parse_input_file() do
    File.stream!("input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  def parse_line(line) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn
      {"@", index}, acc ->
        Map.put(acc, index, 1)

      _, acc ->
        acc
    end)
  end

  def find_accessible_rolls(lines) do
    case find_accessible_rolls(lines, nil, []) do
      {0, new_lines} ->
        new_lines
        |> Enum.each(fn line ->
          1..140
          |> Enum.map(fn x ->
            Map.get(line, x, ".")
          end)
          |> Enum.join()
          |> IO.inspect()
        end)

        0

      {x_count, updated_lines} ->
        x_count + find_accessible_rolls(updated_lines)
    end
  end

  def find_accessible_rolls([], _, updated_lines) do
    new_lines =
      updated_lines
      |> Enum.reverse()
      |> Enum.map(&Map.new/1)

    x_count =
      new_lines
      |> Enum.map(&Enum.count(&1, fn {_, x} -> x == "x" end))
      |> Enum.sum()

    {x_count,
     new_lines |> Enum.map(&Enum.filter(&1, fn {_, x} -> x != "x" end)) |> Enum.map(&Map.new/1)}
  end

  def find_accessible_rolls([line | next_lines], previous_line, updated_lines) do
    find_accessible_rolls(
      next_lines,
      line,
      [
        mark_accessible_rolls(
          line,
          List.first(next_lines),
          previous_line
        )
        | updated_lines
      ]
    )
  end

  def mark_accessible_rolls(line, next_line, previous_line) do
    Enum.map(line, fn {index, _} ->
      case count_adjacent_rolls(index, line, next_line, previous_line) do
        x when x < 4 -> {index, "x"}
        _ -> {index, 1}
      end
    end)
  end

  def count_adjacent_rolls(index, line, nil, previous_line) do
    Map.get(line, index + 1, 0) +
      Map.get(line, index - 1, 0) +
      Map.get(previous_line, index - 1, 0) +
      Map.get(previous_line, index, 0) +
      Map.get(previous_line, index + 1, 0)
  end

  def count_adjacent_rolls(index, line, next_line, nil) do
    Map.get(line, index + 1, 0) +
      Map.get(line, index - 1, 0) +
      Map.get(next_line, index - 1, 0) +
      Map.get(next_line, index, 0) +
      Map.get(next_line, index + 1, 0)
  end

  def count_adjacent_rolls(index, line, next_line, previous_line) do
    Map.get(line, index + 1, 0) +
      Map.get(line, index - 1, 0) +
      Map.get(next_line, index - 1, 0) +
      Map.get(next_line, index, 0) +
      Map.get(next_line, index + 1, 0) +
      Map.get(previous_line, index - 1, 0) +
      Map.get(previous_line, index, 0) +
      Map.get(previous_line, index + 1, 0)
  end
end

IO.puts("Accessible rolls of paper: #{inspect(PaperRolls.compute())}")
