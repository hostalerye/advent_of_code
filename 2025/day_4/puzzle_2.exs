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
    case find_accessible_rolls_iteration(lines, nil, {0, []}) do
      {0, updated_lines} ->
        display_lines(updated_lines)
        0

      {x_count, updated_lines} ->
        x_count + find_accessible_rolls(updated_lines)
    end
  end

  def display_lines(lines) do
    lines
    |> Enum.each(fn line ->
      0..139
      |> Enum.map(fn x ->
        Map.get(line, x, ".")
      end)
      |> Enum.map(fn
        0 -> "."
        1 -> "@"
        "." -> "."
      end)
      |> Enum.join()
      |> IO.inspect()
    end)
  end

  def find_accessible_rolls_iteration([], _, {x_count, updated_lines}) do
    {x_count, updated_lines |> Enum.reverse()}
  end

  def find_accessible_rolls_iteration(
        [line | next_lines],
        previous_line,
        {x_count, updated_lines}
      ) do
    {x_count_line, updated_line} =
      mark_accessible_rolls(
        line,
        List.first(next_lines),
        previous_line
      )

    find_accessible_rolls_iteration(
      next_lines,
      line,
      {x_count + x_count_line, [updated_line | updated_lines]}
    )
  end

  def mark_accessible_rolls(line, next_line, previous_line) do
    Enum.reduce(line, {0, %{}}, fn
      {index, 1}, {x_count, updated_line} ->
        case count_adjacent_rolls(index, line, next_line, previous_line) do
          x when x < 4 -> {x_count + 1, Map.put(updated_line, index, 0)}
          _ -> {x_count, Map.put(updated_line, index, 1)}
        end

      {index, 0}, {x_count, updated_line} ->
        {x_count, Map.put(updated_line, index, 0)}
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
