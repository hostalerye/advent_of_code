defmodule InventoryManagement do
  def compute do
    parse_input_file()
    |> merge_ranges([])
    |> Enum.reduce(0, fn {from, to}, count ->
      count + (to - from + 1)
    end)
  end

  def parse_input_file do
    File.stream!("input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.reduce_while([], fn line, ranges ->
      case String.split(line, "-") do
        [""] ->
          {:halt, ranges}

        [range_start, range_end] ->
          {:cont, [{String.to_integer(range_start), String.to_integer(range_end)} | ranges]}
      end
    end)
    |> List.keysort(0)
  end

  def merge_ranges([], merged_ranges), do: merged_ranges

  def merge_ranges([{from, to} | ranges], []), do: merge_ranges(ranges, [{from, to}])

  def merge_ranges([{from, to} | ranges], [{prev_from, prev_to} | rest]) do
    if from <= prev_to + 1 do
      merge_ranges(ranges, [{prev_from, max(to, prev_to)} | rest])
    else
      merge_ranges(ranges, [{from, to} | [{prev_from, prev_to} | rest]])
    end
  end
end

IO.inspect(InventoryManagement.compute())
