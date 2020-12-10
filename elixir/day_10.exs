defmodule AOC2020Day10 do
  def parse() do
    File.read!("inputs/day-10.puzzle.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
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

  def list_possibilities(possibilities_by_adapter, adapters, acc) do
    current = List.first(adapters)
    next_adapters = Map.get(possibilities_by_adapter, current)

    cond  do
      next_adapters && length(next_adapters) > 0 ->
      Enum.reduce(next_adapters, [], fn
        adapter, r_acc ->
          filtered = Enum.filter(adapters, fn a -> a > adapter end)
          combinaisons = list_possibilities(possibilities_by_adapter, [adapter] ++ filtered, acc ++ [current])
          r_acc ++ Enum.map(combinaisons, fn rest -> rest end)
      end)
      true -> [acc ++ adapters]
    end
  end

  def traverse(possibilities_by_adapter, current, acc) do
    next_adapters = Map.get(possibilities_by_adapter, current)
    cond  do
      next_adapters && length(next_adapters) > 0 -> acc + Enum.reduce(next_adapters, 0, fn adapter, r_acc -> r_acc + traverse(possibilities_by_adapter, adapter, 0)  end)
      true -> 1
    end
  end

  def part2() do
    adapters = parse()
    IO.inspect(adapters)
    adapters = List.insert_at(adapters, 0, 0)
    adapters = adapters ++ [List.last(adapters) + 3]

    possibilities_by_adapter = Enum.reduce(adapters, %{}, fn adapter, acc ->
      Map.put(acc, adapter, Enum.filter(adapters, fn a -> a > adapter && a - adapter <= 3  end))
    end)
    IO.inspect(possibilities_by_adapter)

    idx = Enum.find_index(adapters, fn a -> a == 77  end) |> IO.inspect

    length(Map.keys(possibilities_by_adapter)) |>IO.inspect
    a = traverse(Map.take(possibilities_by_adapter, Map.keys(possibilities_by_adapter) |> Enum.filter(fn n -> n < 77 end)), 0, 0)
    b = traverse(Map.take(possibilities_by_adapter, Map.keys(possibilities_by_adapter) |> Enum.filter(fn n -> n >= 77 end)), 77, 0)
    a * b
  end
end


#AOC2020Day10.part1() |> IO.inspect
AOC2020Day10.part2() |> IO.inspect
