defmodule Factory do
  def compute do
    parse_file()
    |> Enum.map(&find_valid_combinations(&1, 1))
    |> Enum.sum()
  end

  defp parse_file do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&parse_line/1)
    |> Enum.map(&analyze_line/1)
  end

  defp find_valid_combinations(%{buttons: buttons, active_light_indexes: active_light_indexes}, k) do
    combinations = combinations(buttons, k)

    succes? =
      combinations
      |> Enum.any?(fn combo ->
        light_with_combo =
          combo
          |> List.flatten()
          |> Enum.frequencies()
          |> Enum.filter(fn {_, count} -> rem(count, 2) == 1 end)
          |> Enum.map(fn {light, _} -> light end)

        light_with_combo == active_light_indexes
      end)

    if succes? do
      k
    else
      find_valid_combinations(
        %{buttons: buttons, active_light_indexes: active_light_indexes},
        k + 1
      )
    end
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []

  defp combinations([h | t], k) do
    for(combo <- combinations(t, k - 1), do: [h | combo]) ++ combinations(t, k)
  end

  defp parse_line(line_components) do
    parse_line_rec(line_components, %{buttons: []})
  end

  defp parse_line_rec([], elements), do: elements

  defp parse_line_rec([head | tail], elements) do
    parse_line_rec(
      tail,
      case parse_line_element(head) do
        {:light, light} -> Map.put_new(elements, :light, light)
        {:button, button} -> %{elements | buttons: [button | elements.buttons]}
        nil -> elements
      end
    )
  end

  defp parse_line_element("[" <> element) do
    {:light,
     element
     |> String.replace_trailing("]", "")
     |> String.codepoints()}
  end

  defp parse_line_element("(" <> element) do
    {:button,
     element
     |> String.replace_trailing(")", "")
     |> String.split(",")
     |> Enum.map(&String.to_integer/1)}
  end

  defp parse_line_element(_) do
    nil
  end

  defp analyze_line(%{buttons: buttons, light: light}) do
    active_light_indexes =
      light
      |> Enum.with_index()
      |> Enum.filter(fn {light, _} -> light == "#" end)
      |> Enum.map(fn {_, index} -> index end)

    %{
      buttons: buttons,
      active_light_indexes: active_light_indexes
    }
  end
end

IO.inspect(Factory.compute())
