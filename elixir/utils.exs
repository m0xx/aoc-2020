defmodule Utils do
  def to_letters(str) do
    0..String.length(str) - 1
    |> Enum.map(fn i -> String.at(str, i) end)
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

  def combinaisons(1, items, current), do: Enum.map(items, fn item -> current ++ [item] end)
  def combinaisons(length, items, current), do: Enum.reduce(items, [], fn item, acc -> acc ++ combinaisons(length - 1, Enum.slice(items, Enum.find_index(items,
    fn i -> i == item end) + 1, length(items)), current ++ [item])  end)
  def combinaisons(length, items), do: combinaisons(length, items, [])


  defp avg(total, count), do: total / count
  defp format_result(duration, count), do: IO.puts("Average elapsed time (#{count} times): #{duration/1000}ms")

  def benchmark(count, fun) do
      1..count
       |> Enum.map(fn i -> :timer.tc(fun) end)
       |> Enum.map(fn {t, r} -> t end)
       |> Enum.sum
       |> avg(count)
       |> format_result(count)
  end
end
