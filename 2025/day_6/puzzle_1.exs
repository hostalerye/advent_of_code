defmodule CephalopodMath do
  def compute() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.zip()
    |> Enum.map(fn {a, b, c, d, operator} ->
      numbers = [
        String.to_integer(a),
        String.to_integer(b),
        String.to_integer(c),
        String.to_integer(d)
      ]

      case operator do
        "+" -> Enum.sum(numbers)
        "*" -> Enum.product(numbers)
      end
    end)
    |> Enum.sum()
  end
end

IO.inspect(CephalopodMath.compute())
