defmodule CephalopodMath do
  def compute() do
    parse_input_file()
  end

  def parse_input_file() do
    [numbers_1, numbers_2, numbers_3, numbers_4, operators] =
      File.read!("input.txt")
      |> String.split("\n", trim: true)

    operators = String.split(operators, " ", trim: true)

    numbers =
      parse_numbers(
        String.codepoints(numbers_1),
        String.codepoints(numbers_2),
        String.codepoints(numbers_3),
        String.codepoints(numbers_4),
        ["|"],
        false
      )
      |> Enum.reduce(%{current: [], global: []}, fn
        "|", %{current: current, global: global} ->
          %{current: [], global: [current | global]}

        number, %{current: current, global: global} ->
          %{current: [number | current], global: global}
      end)

    Enum.zip(numbers.global, operators)
    |> Enum.map(fn {numbers, operator} ->
      case operator do
        "+" -> Enum.sum(numbers)
        "*" -> Enum.product(numbers)
      end
    end)
    |> Enum.sum()
  end

  def parse_numbers([], [], [], [], aggregate, _), do: aggregate

  def parse_numbers(
        [" " | numbers_1],
        [" " | numbers_2],
        [" " | numbers_3],
        [" " | numbers_4],
        aggregate,
        true
      ) do
    parse_numbers(numbers_1, numbers_2, numbers_3, numbers_4, ["|" | aggregate], false)
  end

  def parse_numbers(
        [" " | numbers_1],
        [" " | numbers_2],
        [" " | numbers_3],
        [" " | numbers_4],
        aggregate,
        false
      ) do
    parse_numbers(numbers_1, numbers_2, numbers_3, numbers_4, aggregate, false)
  end

  def parse_numbers(
        [n1 | numbers_1],
        [n2 | numbers_2],
        [n3 | numbers_3],
        [n4 | numbers_4],
        aggregate,
        _
      ) do
    column_number =
      [n1, n2, n3, n4]
      |> Enum.filter(&(&1 != " "))
      |> Enum.join("")
      |> String.to_integer()

    parse_numbers(numbers_1, numbers_2, numbers_3, numbers_4, [column_number | aggregate], true)
  end
end

IO.inspect(CephalopodMath.compute())
