Code.require_file("elixir/utils.exs")

defmodule AOC2020Day09 do
  def parse() do
    File.read!("inputs/day-09.puzzle.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  def find_weakness(preambles, numbers) do
    if(Enum.empty?(numbers)) do
      :not_found
    end

    current_number = Enum.at(numbers, 0)
    previous_sums = Utils.combinaisons(2, preambles)
         |> Enum.map(fn [a, b] -> a + b end)

    if(current_number in previous_sums) do
      next_preambles = preambles ++ [current_number] |> Enum.reverse |> Enum.take(length(preambles)) |> Enum.reverse
      find_weakness(next_preambles, List.delete_at(numbers, 0) )
    else
      current_number
    end
  end

  def find_contiguous_set(numbers, index, acc) when index >= length(numbers) do
    {:not_found, acc}
  end

  def find_contiguous_set(numbers, weakness, index, acc) do
    number = Enum.at(numbers, index)
    acc = number + acc

    cond  do
      (acc > weakness) -> find_contiguous_set(List.delete_at(numbers, 0), weakness, 0, 0)
      (acc == weakness) -> {:found, Enum.take(numbers, index + 1)}
      true -> find_contiguous_set(numbers, weakness, index + 1, acc)
    end
  end

  def part1() do
    all = parse()
    preamble = Enum.take(all, 25)
    numbers = all -- preamble

    find_weakness(preamble, numbers)
  end

  def part2() do
    all = parse()
    preamble = Enum.take(all, 25)
    numbers = all -- preamble

   find_contiguous_set(all, find_weakness(preamble, numbers), 0, 0)
      |> (fn {:found, contiguous_set} ->  Enum.min(contiguous_set) + Enum.max(contiguous_set) end).()
  end
end


AOC2020Day09.part1() |> IO.inspect
AOC2020Day09.part2() |> IO.inspect
