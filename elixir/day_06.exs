defmodule AOC2020Day06 do
  def parse() do
    File.read!("inputs/day-06.sample.txt")
      |> String.split("\n", trim: true)
  end

  def part1() do
    parse()
  end

  def part2() do
    parse()
  end
end


AOC2020Day06.part1() |> IO.inspect
AOC2020Day06.part2() |> IO.inspect
