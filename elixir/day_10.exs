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

  def list_possibilities(possibilities_by_adapter, adapters, acc) do
    current = List.last(adapters[0])
    next_adapters = Map.get(possibilities_by_adapter, current)

    cond  do
      next_adapters && length(next_adapters) > 0 ->
        Enum.map(fn adapter ->
          list_possibilities(
                            possibilities_by_adapter,
                            List.filter(fn a -> a > adapter end),
                            acc ++ [current])
        end)
      true -> [acc ++ adapters]
    end
  end
  def part2() do
    adapters = parse()
    possibilities_by_adapter = Enum.reduce(adapters, %{}, fn adapter, acc ->
      Map.put(acc, adapter, Enum.filter(adapters, fn a -> a > adapter && a - adapter <= 3  end))
    end)

    adapters
      |> list_possibilities(possibilities_by_adapter, adapters, [])
  end
end


#AOC2020Day10.part1() |> IO.inspect
AOC2020Day10.part2() |> IO.inspect
