defmodule Laboratories do
  def compute() do
    parse_file()
    |> cast_tachyon(nil)
  end

  def parse_file() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.map(&Enum.into(&1, %{}, fn {k, v} -> {v, k} end))
  end

  def cast_tachyon([], _), do: 0

  def cast_tachyon([line | next_lines], nil) do
    cast_tachyon(next_lines, line)
  end

  def cast_tachyon([line | next_lines], previous_line) do
    {updated_line, new_tachyons} =
      Enum.reduce(previous_line, {line, 0}, fn
        {k, "S"}, {current_line, new_tachyons} ->
          {Map.put(current_line, k, "|"), new_tachyons}

        {k, "|"}, {current_line, new_tachyons} ->
          case Map.get(current_line, k) do
            "." ->
              {Map.put(current_line, k, "|"), new_tachyons}

            "^" ->
              case {Map.get(current_line, k + 1), Map.get(current_line, k - 1)} do
                {".", "."} ->
                  {current_line |> Map.put(k + 1, "|") |> Map.put(k - 1, "|"), new_tachyons + 1}

                {_, "|"} ->
                  {Map.put(current_line, k + 1, "|"), new_tachyons + 1}

                {"|", _} ->
                  {Map.put(current_line, k - 1, "|"), new_tachyons + 1}
              end

            _ ->
              {current_line, new_tachyons}
          end

        {_k, _}, {current_line, new_tachyons} ->
          {current_line, new_tachyons}
      end)

    updated_line
    |> Enum.into([])
    |> Enum.sort(fn {k1, _}, {k2, _} -> k1 < k2 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join()
    |> IO.inspect()

    new_tachyons + cast_tachyon(next_lines, updated_line)
  end
end

IO.inspect(Laboratories.compute())
