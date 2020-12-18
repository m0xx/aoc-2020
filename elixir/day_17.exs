Code.require_file("elixir/utils.exs")
Code.require_file("elixir/three_d_grid.exs")

defmodule AOC2020Day17 do
  def parse(three_d_grid) do
    File.read!("inputs/day-17.puzzle.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(
         fn {row, y} ->
           String.split(row, "", trim: true)
           |> Enum.map(&state/1)
           |> Enum.with_index()
           |> Enum.map(fn {state, x} -> {%ThreeDGrid.Point{x: x, y: y, z: 0}, state} end)
         end
       )
    |> List.flatten()
  end

  def cycle(three_d_grid) do
    three_d_grid = ThreeDGrid.get_all_points(three_d_grid)
                   |> Enum.reduce(
                        three_d_grid,
                        fn point, a_three_d_grid ->
                          neighbors = ThreeDGrid.neighbors(three_d_grid, point)
                          Enum.reduce(
                            neighbors,
                            a_three_d_grid,
                            fn {n_point, value}, a_a_three_d_grid ->
                              case ThreeDGrid.exists?(a_a_three_d_grid, n_point) do
                                true -> a_a_three_d_grid
                                false -> ThreeDGrid.update(a_a_three_d_grid, n_point, value)
                              end
                            end
                          )
                        end
                      )

    ThreeDGrid.get_all_points(three_d_grid)
    |> Enum.reduce(
         three_d_grid,
         fn point, a_three_d_grid ->
           active_neighbors = ThreeDGrid.neighbors(three_d_grid, point)
                              |> Enum.map(fn {point, value} -> value end)
                              |> Enum.filter(&(&1 == :active))
           state = ThreeDGrid.get_value(three_d_grid, point)

           ThreeDGrid.update(a_three_d_grid, point, next_state(active_neighbors, state))
         end
       )
  end


  def next_state(active_neighbors, :active) do
    case length(active_neighbors) do
      2 -> :active
      3 -> :active
      _ -> :inactive
    end
  end

  def next_state(active_neighbors, :inactive) do
    case length(active_neighbors) do
      3 -> :active
      _ -> :inactive
    end
  end

  def state("#"), do: :active
  def state("."), do: :inactive

  def format_state(:active), do: "#"
  def format_state(:inactive), do: "."

  def part1() do
    three_d_grid = ThreeDGrid.init_grid(3, 3, 1, :inactive)
    three_d_grid = parse(three_d_grid)
                   |> Enum.reduce(
                        three_d_grid,
                        fn {point, state}, a_three_d_grid ->
                          ThreeDGrid.update(a_three_d_grid, point, state)
                        end
                      )

#    ThreeDGrid.neighbors(three_d_grid, %ThreeDGrid.Point{x: 1, y: 1, z: 0}) |> Enum.count()

    three_d_grid = 0..5
      |> Enum.reduce(three_d_grid, fn c, a_three_d_grid ->
      a_three_d_grid = cycle(a_three_d_grid)
      IO.puts "Cycle #{c}"
      ThreeDGrid.get_z_indexes(a_three_d_grid)
        |> Enum.each(fn z -> ThreeDGrid.display_z(a_three_d_grid, z, &format_state/1) end)

      IO.puts "\n"
      a_three_d_grid
    end)
    ThreeDGrid.get_all_points(three_d_grid)
    |> Enum.filter(&(ThreeDGrid.get_value(three_d_grid, &1) == :active))
    |> Enum.count()
  end

  def part2() do
    #    parse()
  end
end


AOC2020Day17.part1()
|> IO.inspect
#AOC2020Day17.part2() |> IO.inspect
