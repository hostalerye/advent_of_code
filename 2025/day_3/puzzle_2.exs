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
    find_next_greatest_combination(int_list, 12)
  end

  def find_next_greatest_combination(_int_list, 0), do: 0

  def find_next_greatest_combination(int_list, index) do
    greatest =
      int_list
      |> Enum.slice(0..-index//1)
      |> Enum.max()

    greatest_index = Enum.find_index(int_list, fn x -> x == greatest end)

    Integer.pow(10, index - 1) * greatest +
      find_next_greatest_combination(Enum.slice(int_list, (greatest_index + 1)..-1//1), index - 1)
  end

  def line_to_int_list(line) do
    line
    |> String.trim()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end
end

IO.puts("Sum of best combinations is #{Batteries.compute()}")
