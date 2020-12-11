Code.require_file("elixir/utils.exs")

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

  # Special thanks to @reobin (https://github.com/reobin)
  # He shared me this blazing fast algorithm, this guy's is a beast.
  def count_arrangements(adapters) do
    Enum.reduce(0..length(adapters) - 2, %{}, fn i, acc ->
      adapter = Enum.at(adapters, i)
      acc = Map.put_new(acc, adapter, 1)

      Enum.reduce(i + 1..length(adapters) - 1, acc, fn j, arrangements ->
        next_adapter = Enum.at(adapters, j);
        arrangements = Map.put_new(arrangements, next_adapter, 0)
        diff = next_adapter - adapter
        if diff <= 3 do
          Map.update!(arrangements, next_adapter, &(&1 + Map.get(arrangements, adapter)))
        else
          arrangements
        end
      end)
    end)
    |> Map.get(List.last(adapters))
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
    adapters = [0] ++ adapters ++ [List.last(adapters) + 3]

    count_arrangements(adapters)
  end

end


AOC2020Day10.part1() |> IO.inspect
AOC2020Day10.part2() |> IO.inspect
