defmodule Dial do
  def compute do
    File.stream!("input.txt")
    |> Enum.reduce(%{res: 0, pos: 50}, &parse_line/2)
  end

  defp parse_line("R" <> count, %{res: res, pos: pos}) do
    {new_pos, ticks} = turn_righ(pos, parse_count(count))
    %{res: res + ticks, pos: new_pos}
  end

  defp parse_line("L" <> count, %{res: res, pos: pos}) do
    {new_pos, ticks} = turn_left(pos, parse_count(count))
    %{res: res + ticks, pos: new_pos}
  end

  defp parse_count(count), do: count |> String.trim() |> String.to_integer()

  defp turn_righ(from, by) do
    count_ticks(from + by)
  end

  defp turn_left(from, by) do
    count_ticks(from - by)
  end

  defp count_ticks(position) when position > 100 do
    count_ticks(position - 100)
  end

  defp count_ticks(position) when position < 0 do
    count_ticks(position + 100)
  end

  defp count_ticks(position) when position in [0, 100] do
    {0, 1}
  end

  defp count_ticks(position) do
    {position, 0}
  end
end

IO.puts("Result is #{Dial.compute().res}")
