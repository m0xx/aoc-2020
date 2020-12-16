defmodule Point do
  defstruct [:x, :y]

  def add(p1, p2) do
    %Point{x: p1.x + p2.x, y: p1.y + p2.y}
  end
end

defmodule PuzzleMap do
  def init_map(nb_col, nb_row, default_value) do
    Enum.map(0..nb_col, fn x ->
      Enum.map(0..nb_row, fn y -> %Point{x: x, y: y} end)
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn point, map -> Map.put(map, point, default_value)  end)
  end

  def rows(map) do
    Map.keys(map)
      |> Enum.map(fn point -> point.x end)
      |> Enum.uniq()
      |> Enum.sort()
  end

  def cols(map) do
    Map.keys(map)
      |> Enum.map(fn point -> point.y end)
      |> Enum.uniq()
      |> Enum.sort()
  end

end


