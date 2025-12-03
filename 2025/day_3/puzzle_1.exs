defmodule Batteries do
  def compute() do
    parse_input_file()
    |> Enum.map(&find_greatest_combination(&1))
    |> Enum.sum()
  end

  def parse_input_file() do
    File.stream!("input.txt")
  end

  def find_greatest_combination(line) do
    int_list = line_to_int_list(line)
    greatest = Enum.max(int_list)

    case Enum.count(int_list, fn x -> x == greatest end) do
      1 -> find_greatest_combination_with(int_list, greatest)
      _ -> greatest * 10 + greatest
    end
  end

  def find_greatest_combination_with(int_list, greatest) do
    case Enum.chunk_by(int_list, fn x -> x == greatest end) do
      [sub_list, [greatest]] -> 10 * Enum.max(sub_list) + greatest
      [[greatest], sub_list] -> 10 * greatest + Enum.max(sub_list)
      [_, [greatest], sub_list] -> 10 * greatest + Enum.max(sub_list)
    end
  end

  def line_to_int_list(line) do
    line
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end

IO.puts("Sum of best combinations is #{Batteries.compute()}")
