defmodule InventoryManagement do
  def compute do
    parse_input_file()
    |> find_fresh_ingredients()
    |> Enum.count()
  end

  def parse_input_file do
    File.stream!("input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({[], []}, fn line, {ingredients, ranges} ->
      case String.split(line, "-") do
        [""] ->
          {ingredients, ranges}

        [range_start, range_end] ->
          {ingredients,
           [Range.new(String.to_integer(range_start), String.to_integer(range_end)) | ranges]}

        [ingredient_id] ->
          {[String.to_integer(ingredient_id) | ingredients], ranges}
      end
    end)
  end

  def find_fresh_ingredients({ingredients, ranges}) do
    Enum.filter(ingredients, fn ingredient ->
      Enum.any?(ranges, fn
        from..to//1 when ingredient >= from and ingredient <= to ->
          true

        _ ->
          false
      end)
    end)
  end
end

IO.puts("#{InventoryManagement.compute()} fresh ingredients found")
