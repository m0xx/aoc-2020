defmodule AOC2020Day02 do
  def parse() do
    File.read!("inputs/day-02.puzzle.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        regex = ~r/^(?<lb>\d+)-(?<ub>\d+) (?<letter>[a-z]): (?<password>[a-z]+)$/
        case Regex.named_captures(regex, line) do
          %{"lb" => lb, "ub" => ub, "letter" => _letter, "password" => _password} = parsed_line ->
            %{parsed_line | "lb" => String.to_integer(lb), "ub" => String.to_integer(ub) }
        end
      end)
  end

  def valid_password?(%{"lb" => lb, "ub" => ub, "letter" => letter, "password" => password}) do
    occurrences =
      password
      |> String.graphemes()
      |> Enum.filter(&(&1 == letter))
      |> Enum.count()

    lb <= occurrences && occurrences <= ub
  end

  def valid_password2?(%{"lb" => lb, "ub" => ub, "letter" => letter, "password" => password}) do
    letters = String.graphemes(password)

    [Enum.at(letters, lb - 1) == letter, Enum.at(letters, ub - 1) == letter]
      |> Enum.filter(fn l -> l == true end)
      |> Enum.count
      |> (fn count -> count == 1 end).()
  end

  def part1() do
    parse()
      |> Enum.filter(&valid_password?/1)
      |> Enum.count()
  end

  def part2() do
    parse()
    |> Enum.filter(&valid_password2?/1)
    |> Enum.count()
  end
end


AOC2020Day02.part1() |> IO.inspect
AOC2020Day02.part2() |> IO.inspect
