Code.require_file("elixir/utils.exs")

defmodule AOC2020Day01 do
  def parse() do
    File.read!("inputs/day-01.puzzle.txt")
      |> String.split("\n", trim: true)
  end

  def part1() do
    parse()
      |> Enum.map(&String.to_integer/1)
      |> (fn expenses -> Utils.combinaisons(2, expenses) end).()
      |> Enum.find(fn [a, b] -> a + b == 2020 end)
      |> (fn [a,b] -> a * b end).()
  end

  def part2() do
    parse()
    |> Enum.map(&String.to_integer/1)
    |> (fn expenses -> Utils.combinaisons(3, expenses) end).()
    |> Enum.find(fn [a, b, c] -> a + b + c == 2020 end)
    |> (fn [a, b, c] -> a * b * c end).()
  end
end

AOC2020Day01.part1() |> IO.inspect
AOC2020Day01.part2() |> IO.inspect
