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
    |> Stream.filter(&(&1 > 10))
    |> Stream.filter(fn value_int ->
      value_int
      |> Integer.to_string()
      |> is_invalid?()
    end)
    |> Enum.sum()
  end

  def is_invalid?(value) do
    middle = div(String.length(value), 2)

    1..middle
    |> Enum.any?(fn chunk_size ->
      value
      |> String.codepoints()
      |> Enum.chunk_every(chunk_size)
      |> Enum.map(&Enum.join/1)
      |> Enum.uniq()
      |> (&(Enum.count(&1) == 1)).()
    end)
  end
end

IO.puts(IDCleaner.compute())
