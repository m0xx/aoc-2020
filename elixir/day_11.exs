Code.require_file("elixir/utils.exs")

defmodule AOC2020Day11 do
  def to_seat(letter) do
    case letter do
      "L" -> :empty
      "#" -> :occupied
      "." -> :floor
    end
  end

  defmodule Seat do
    defstruct [:x, :y, :state]
  end

  def in_layout?(layout, {x,y}) do
    nb_row = length(layout)
    nb_col = length(Enum.at(layout, 0))

    x < nb_col && x >= 0 && y < nb_row && y >= 0
  end

  def get_seat(layout, {x,y}) do
    Enum.at(Enum.at(layout, y), x)
  end

  def adjacent_seats(layout, seat, length_per_direction) do

    [
      [-1, 1],
      [-1, 0],
      [-1, -1],
      [1, 1],
      [1, 0],
      [1, -1],
      [0, 1],
      [0, -1]
    ]
      |> Enum.map(fn [x_offset, y_offset] ->
          Enum.reduce_while(1..length_per_direction, [], fn idx ->
            [n_x_offset, n_y_offset] = [x_offset * idx, y_offset * idx]

            [next_x, next_y] = [n_x_offset + seat.x, n_y_offset + seat.y]

            cond do
              not in_layout?(layout,[next_x, next_y]) -> {:halt, [n_x_offset, n_y_offset]}
              get_seat(layout, {next_x, next_y}).state == :floor -> {:cont, [n_x_offset, n_y_offset]}
              true -> {:halt, [n_x_offset, n_y_offset]}
            end
          end)
      end)
     |> Enum.filter(fn [x_offset, y_offset] ->
        in_layout?(layout, {seat.x + x_offset, seat.y + y_offset})
    end)
     |> Enum.map(fn [x_offset, y_offset] -> Enum.at(Enum.at(layout, seat.y + y_offset),  seat.x + x_offset) end)
  end

  def apply_rule(seat, adj_seats) do
    case seat.state do
      :empty -> apply_rule_empty(seat, adj_seats)
      :occupied -> apply_rule_occupied(seat, adj_seats)
      _ -> seat
    end
  end

  def apply_rule_empty(seat, adj_seats) do
      has_adj_occupied_seat = Enum.any?(adj_seats, fn s -> s.state == :occupied end)
      case has_adj_occupied_seat do
         true -> seat
         _ -> %Seat{ seat | state: :occupied}
      end
  end

  def apply_rule_occupied(seat, adj_seats) do
    count_adj_occupied_seat = Enum.filter(adj_seats, fn s -> s.state == :occupied end) |> length
    if count_adj_occupied_seat >= 4 do
      %Seat{ seat | state: :empty}
    else
      seat
    end
  end
  #def is_adjacent_occ(layout, seat_ref, seat_adj), do: false when seat_adj.x >= length(Enum.at(layout, 0))
  #def is_adjacent_occ(layout, seat_ref, seat_adj), do: false when seat_adj.y >= length(layout)
  #def is_adjacent_occ(layout, seat_ref, seat_adj), do: seat_adj.is_occupied

  def parse() do
    layout = File.read!("inputs/day-11.sample.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true) |> Enum.map(fn a -> to_seat(a) end))

    Enum.map(0..length(layout) - 1, fn y ->
      row = Enum.at(layout, y);
      Enum.map(0..length(row) - 1, fn x ->
        %Seat{x: x, y: y, state: Enum.at(row, x)}
      end)
    end)
  end

  def simulate(layout, length_per_direction) do
      seats = List.flatten(layout)

      Enum.reduce(seats, layout, fn seat, inner_layout ->
        next_seat = apply_rule(seat, adjacent_seats(layout, seat, length_per_direction))
        row = Enum.at(inner_layout, seat.y)

        List.replace_at(inner_layout, seat.y, List.replace_at(row, seat.x, next_seat))
      end)
  end

  def same_layout?(l1, l2) when length(l1) != length(l2), do: false
  def same_layout?(l1, l2) do
    Enum.with_index(l1)
      |> Enum.take_while(fn {row, y} ->
          Enum.with_index(row)
            |> Enum.take_while(fn {seat, x} -> seat.state == Enum.at(Enum.at(l2, y), x).state end)
            |> Enum.count() == length(row)
        end)
      |> Enum.count() == length(l1)
  end

  def format_layout(layout) do
    Enum.each(layout, fn row ->
      Enum.map(row, fn seat ->
        case seat.state do
          :empty -> "L"
          :occupied -> "#"
          :floor -> "."
        end
      end)
      |> IO.puts
    end)

    IO.puts("\n\n")
  end
  def part1() do
    layout = parse()
    length_per_direction = 1;

    Enum.reduce_while(0..100000, {1, layout}, fn x, {count, prev} ->
        IO.puts(count)
        format_layout(prev)
        next = simulate(prev, length_per_direction)
        if same_layout?(prev, next) do
          {:halt, {count, next}}
        else
          {:cont, {count + 1, next}}
        end
    end)
      |> (fn {count, layout} -> List.flatten(layout) end).()
      |> Enum.filter(fn seat -> seat.state == :occupied  end)
      |> Enum.count()
  end

  def part2() do
    layout = parse()

    1..5
      |> Enum.to_list()
  end
end


AOC2020Day11.part1() |> IO.inspect
#AOC2020Day11.part2() |> IO.inspect
