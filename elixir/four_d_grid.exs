defmodule FourDGrid do
  defstruct [:nb_row, :nb_col, :depth, :nb_w, :grid, :default_value]

  defmodule Point do
    defstruct [:x, :y, :z, :w]

    def add(p1, p2) do
      %Point{x: p1.x + p2.x, y: p1.y + p2.y, z: p1.z + p2.z, w: p1.w + p2.w}
    end
  end

  def init_grid(nb_col, nb_row, depth, nb_w, default_value) do
    Enum.map(
      0..nb_col - 1,
      fn x ->
        Enum.map(
          0..nb_row - 1,
          fn y ->
            Enum.map(
              0..depth - 1,
              fn z ->
                Enum.map(
                  0..nb_w - 1,
                  fn w ->
                    %Point{x: x, y: y, z: z, w: w}
                  end
                )
              end
            )
          end
        )
      end
    )
    |> List.flatten()
    |> Enum.reduce(%{}, fn point, map -> Map.put(map, point, default_value)  end)
    |> (fn grid -> %{
                     nb_col: nb_col,
                     nb_row: nb_row,
                     depth: depth,
                     nb_w: nb_w,
                     grid: grid,
                     default_value: default_value
                   }
        end).()
  end

  #  TODO: refactor in utils
  defp combinaisons(size, values, acc, results) when is_list(acc) and length(acc) == size, do: results ++ [acc]
  defp combinaisons(size, values, acc, results),
       do: Enum.reduce(
         values,
         results,
         fn value, result ->
           combinaisons(size, values, acc ++ [value], result)
         end
       )
  defp combinaisons(size, values), do: combinaisons(size, values, [], [])

  def is_inbound(four_d_grid, point) do
    Map.has_key?(four_d_grid.grid, point)
  end

  def neighbors(four_d_grid, point) do
    combinaisons(4, [-1, 0, 1])
    |> Enum.filter(&(&1 != [0, 0, 0, 0]))
    |> Enum.map(fn [x, y, z, w] -> %{x: x, y: y, z: z, w: w} end)
    |> Enum.map(&Point.add(&1, point))
      #    |> Enum.filter(&(is_inbound(four_d_grid, &1) && &1 != point))
    |> Enum.map(fn point -> {point, get_value(four_d_grid, point)} end)
  end

  def update(four_d_grid, point, value) do
    %{four_d_grid | grid: Map.put(four_d_grid.grid, point, value)}
  end

  def get_value(four_d_grid, point) do
    Map.get(four_d_grid.grid, point, four_d_grid.default_value)
  end

  defp get_axis_indexes(four_d_grid, func) do
    all_indexes = Map.keys(four_d_grid.grid)
                  |> Enum.map(func)
    Enum.min(all_indexes)..Enum.max(all_indexes)
  end

  def get_x_indexes(four_d_grid), do: get_axis_indexes(four_d_grid, &(&1.x))
  def get_y_indexes(four_d_grid), do: get_axis_indexes(four_d_grid, &(&1.y))
  def get_z_indexes(four_d_grid), do: get_axis_indexes(four_d_grid, &(&1.z))
  def get_w_indexes(four_d_grid), do: get_axis_indexes(four_d_grid, &(&1.w))

  def get_all_points(four_d_grid) do
    get_x_indexes(four_d_grid)
    |> Enum.map(
         fn x ->
           get_y_indexes(four_d_grid)
           |> Enum.map(
                fn y ->
                  get_z_indexes(four_d_grid)
                  |> Enum.map(
                       fn z ->
                         get_w_indexes(four_d_grid)
                         |> Enum.map(fn w -> %Point{x: x, y: y, z: z, w: w}  end)
                       end
                     )
                end
              )
         end
       )
    |> List.flatten()
  end

  def exists?(four_d_grid, point) do
    Map.has_key?(four_d_grid.grid, point)
  end

  def display_z_w(four_d_grid, z, w, format_func) do
    IO.puts "Z=#{z} W=#{w}"
    get_y_indexes(four_d_grid)
    |> Enum.map(
         fn y ->
           get_x_indexes(four_d_grid)
           |> Enum.map(&(format_func.(get_value(four_d_grid, %Point{x: &1, y: y, z: z, w: w}))))
           |> Enum.reduce("", fn v, acc -> acc <> v end)
         end
       )
    |> Enum.each(fn row -> IO.puts row end)
  end
end


