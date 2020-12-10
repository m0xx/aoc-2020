defmodule AOC2020Day10 do
  def parse() do
    File.read!("inputs/day-10.sample.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
#      |> (fn adapters -> [0] ++ adapters end).()
  end

  def find_adapter(prev, adapters, rating) do
    current = Enum.at(adapters, 0)
    diff = current - prev

    cond do
      current > rating -> []
      length(adapters) == 1 -> [diff]
      true -> [diff] ++ find_adapter(current, List.delete_at(adapters, 0), rating)
    end

  end

  def part1() do
    adapters = parse()
    find_adapter(0, adapters, List.last(adapters) + 3)
      |> (fn count -> Enum.group_by(count, fn c -> c end)  end).()
      |> Enum.map(fn {k, v} ->
        case k do
          3 -> length(v) + 1
          _ -> length(v)
        end
    end)
      |> (fn [a,b] -> a * b end).()
  end

  def part2() do
    adapters = parse()
    Enum.reduce(adapters, %{}, fn adapter -> Enum.filter(fn a -> a > adapter && a - adapters <= 3  end)  end)
  end
end


AOC2020Day10.part1() |> IO.inspect
#AOC2020Day10.part2() |> IO.inspect
