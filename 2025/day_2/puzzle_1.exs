defmodule IDCleaner do
  def compute do
    ranges()
    |> Enum.map(&find_invalid_ids(&1))
    |> Enum.sum()
  end

  def ranges do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
  end

  def find_invalid_ids([from, to]) do
    from_int = String.to_integer(from)
    to_int = String.to_integer(to)

    from_int..to_int
    |> Stream.filter(fn value_int ->
      value_int
      |> Integer.to_string()
      |> is_invalid?()
    end)
    |> Enum.sum()
  end

  def is_invalid?(value) when rem(length(value), 2) == 1 do
    false
  end

  def is_invalid?(value) do
    value
    |> String.split_at(div(String.length(value), 2))
    |> is_tuple_invalid?()
  end

  def is_tuple_invalid?({first_half, second_half}) when first_half == second_half do
    true
  end

  def is_tuple_invalid?(_) do
    false
  end
end

IO.puts(IDCleaner.compute())
