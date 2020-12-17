Code.require_file("elixir/utils.exs")

defmodule AOC2020Day15 do
  def parse() do
    File.read!("inputs/day-15.puzzle.txt")
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def speak(game) do
    if game.turn <= length(game.starting_numbers) do
      Enum.at(game.starting_numbers, game.turn - 1)
    else
      turns = Map.get(game.spoken, game.last)
      if length(turns) == 1 do
        0
      else
        List.last(turns) - Enum.at(turns, length(turns) - 2)
      end
    end
  end

  def play(game) do
    turn = game.turn
    number = speak(game)

    spoken = Map.update(game.spoken, number, [turn], fn value -> value ++ [turn] end)

    %{game | spoken: spoken, turn: turn + 1, last: number}
  end
  def part1() do
    starting_numbers = parse()

    game = %{
      turn: 1,
      spoken: %{},
      starting_numbers: starting_numbers,
      last: nil
    }

    1..2020
    |> Enum.reduce(game, fn _, a_game -> play(a_game) end)
    |> (fn a_game -> a_game.last end).()
  end

  def part2() do
    parse()
  end
end


AOC2020Day15.part1()
|> IO.inspect
