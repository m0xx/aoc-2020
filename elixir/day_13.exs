Code.require_file("elixir/utils.exs")

defmodule AOC2020Day13 do
  def parse() do
    File.read!("inputs/day-13.puzzle.txt")
    |> String.split("\n", trim: true)
    |> (fn [timestamp, bus] ->
      busIds = String.split(bus, ~r',', trim: true)
      |> Enum.filter(fn id -> id != "x" end)
      |> Enum.map(&String.to_integer/1)

      {String.to_integer(timestamp), busIds}
        end).()
  end

  def next_depart(timestamp, busId) do
    modulo = rem(timestamp, busId)
    case modulo do
      0 -> timestamp
      _ -> timestamp - modulo + busId
    end
  end

  def part1() do
    {timestamp, busIds} = parse()
    busIds
      |> Enum.map(fn busId -> {busId, next_depart(timestamp, busId)} end)
      |> Enum.min_by(fn ({busId, depart}) -> depart end)
      |> (fn {busId, depart} -> busId * (depart - timestamp)  end).()
  end

  def part2() do
    parse()
  end
end


AOC2020Day13.part1()
|> IO.inspect
#AOC2020Day13.part2() |> IO.inspect
