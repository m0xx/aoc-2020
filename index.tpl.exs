defmodule AOC2020Day__DAY__ do
  def parse() do
    File.read!("inputs/day-__DAY__.sample.txt")
      |> String.split("\n", trim: true)
  end

  def part1() do
    parse()
  end

  def part2() do
    parse()
  end
end


AOC2020Day__DAY__.part1() |> IO.inspect
AOC2020Day__DAY__.part2() |> IO.inspect
