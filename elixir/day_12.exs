Code.require_file("elixir/utils.exs")
Code.require_file("elixir/puzzle_map.exs")
defmodule AOC2020Day12 do
  defmodule Ship do
    defstruct [:direction, :point]
  end

  def parse() do
    File.read!("inputs/day-12.puzzle.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(
         fn row ->
           regex = ~r/^(?<action>[A-Z])(?<value>\d+)$/
           case Regex.named_captures(regex, row) do
             %{"action" => action, "value" => value} = _parsed_instruction -> {action, String.to_integer(value)}
             nil -> :empty
           end
         end
       )
  end

  def prev_cardinal(cardinal_direction) do
    case cardinal_direction do
      :north -> :west
      :east -> :north
      :south -> :east
      :west -> :south
    end
  end

  def next_cardinal(cardinal_direction) do
    case cardinal_direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  def turn_left(current_direction, degree) do
    1..round(degree / 90)
    |> Enum.reduce(current_direction, fn _i, direction -> prev_cardinal(direction) end)
  end

  def turn_right(current_direction, degree) do
    1..round(degree / 90)
    |> Enum.reduce(current_direction, fn _i, direction -> next_cardinal(direction) end)
  end

  def move_ship(value, direction, ship, change_direction?) do
    {x, y} = case direction do
      :north -> {0, -1 * value}
      :east -> {value, 0}
      :south -> {0, value}
      :west -> {-1 * value, 0}
    end

    next_direction = if change_direction? do
      direction
    else
      ship.direction
    end
    %{direction: next_direction, point: Point.add(ship.point, %{x: x, y: y})}
  end

  def move({action, value}, ship) do
    case action do
      "N" -> move_ship(value, :north, ship, false)
      "S" -> move_ship(value, :south, ship, false)
      "E" -> move_ship(value, :east, ship, false)
      "W" -> move_ship(value, :west, ship, false)
      "L" -> move_ship(0, turn_left(ship.direction, value), ship, true)
      "R" -> move_ship(0, turn_right(ship.direction, value), ship, true)
      "F" -> move_ship(value, ship.direction, ship, false)
      _ -> ship
    end
  end

  def part1(initial_direction) do
    ship = %{
      direction: initial_direction,
      point: %{
        x: 0,
        y: 0
      }
    }
    parse()
    |> Enum.reduce(ship, fn instruction, a_ship -> move(instruction, a_ship) end)
    |> (fn ship -> abs(ship.point.x) + abs(ship.point.y) end).()
  end

  def part2() do
    parse()
  end
end


AOC2020Day12.part1(:east)
|> IO.inspect


