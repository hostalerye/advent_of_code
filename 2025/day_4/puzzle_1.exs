defmodule PaperRolls do
  def compute do
    parse_input_file()
    |> find_accessible_rolls(nil, 0)
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

  def find_accessible_rolls([], _, accessible_rolls_count), do: accessible_rolls_count

  def find_accessible_rolls([line | next_lines], previous_line, accessible_rolls_count) do
    find_accessible_rolls(
      next_lines,
      line,
      accessible_rolls_count + count_accessible_rolls(line, List.first(next_lines), previous_line)
    )
  end

  def count_accessible_rolls(line, next_line, previous_line) do
    line
    |> Map.keys()
    |> Enum.map(&count_adjacent_rolls(&1, line, next_line, previous_line))
    |> Enum.filter(&(&1 < 4))
    |> Enum.count()
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

IO.puts("Accessible rolls of paper: #{PaperRolls.compute()}")
