Code.require_file("elixir/utils.exs")

defmodule AOC2020Day16 do
  def parse_rules(input_file) do
    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> Enum.map(
         fn row ->
           regex = ~r/^(?<field>.+):\s(?<r1_start>\d+)-(?<r1_end>\d+)\sor\s(?<r2_start>\d+)-(?<r2_end>\d+)$/
           case Regex.named_captures(regex, row) do
             %{
               "field" => field,
               "r1_start" => r1_start,
               "r1_end" => r1_end,
               "r2_start" => r2_start,
               "r2_end" => r2_end
             } = parsed_rule ->
               [
                 %{field: field, start: String.to_integer(r1_start), end: String.to_integer(r1_end)},
                 %{field: field, start: String.to_integer(r2_start), end: String.to_integer(r2_end)}
               ]
             nil ->
               []
           end
         end
       )
     |> List.flatten()
  end

  def parse_nearby_tickets(input_file) do
    content = File.read!(input_file)
    regex = ~r/nearby tickets:\n(?<tickets_raw>(.|\n)+)$/

    case Regex.named_captures(regex, content) do
      %{"tickets_raw" => tickets_raw} = parsed_nearby_tickets -> String.split(tickets_raw, "\n", trim: true)
      _ -> nil
    end
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  def is_valid?(rule, ticket) do
    ticket >= rule.start && ticket <= rule.end
  end

  def part1() do
    input_file = "inputs/day-16.puzzle.txt"
    rules = parse_rules(input_file)

    parse_nearby_tickets(input_file)
    |> Enum.map(fn ticket ->
      {
        ticket,
        Enum.filter(rules, &is_valid?(&1, ticket))
      }
    end)
    |> Enum.filter(fn {ticket, valid_rules} -> length(valid_rules) == 0 end)
    |> Enum.map(fn {ticket, _} -> ticket end)
    |> Enum.sum()
  end

  def part2() do
#    parse_rules()
  end
end


AOC2020Day16.part1()
|> IO.inspect
