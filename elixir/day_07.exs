defmodule AOC2020Day07 do

  def bag_contains(rule, bag, rules) do
    IO.puts("Bag contains:")
    IO.inspect(rule)
    rule["bags"]
      |> Enum.find(fn current_bag->
          case current_bag do
            :empty -> false
            %{"count" => _count, "tone" => tone, "color" => color} ->
              if bag["color"] == color && bag["tone"] == tone do
                true
              else
                bag_contains(find_rule(rules, current_bag), bag, rules)
              end
          end
      end)
    |> (fn found -> found != nil end).()
  end

  def parse_bag(str) do
      str
        |> String.split(",", trim: true)
        |> Enum.map(fn part ->
          regex = ~r/^.*(?<count>\d+)\s(?<tone>[a-z]+)\s(?<color>[a-z]+)\sbag.*$/
          case Regex.named_captures(regex, part) do
              %{"count" => count, "tone" => tone, "color" => color} = parsed_bag -> parsed_bag
              nil -> :empty
          end
        end)
  end

  def parse() do
    File.read!("inputs/day-07.puzzle.txt")
      |> String.split("\n", trim: true)
     |> Enum.map(fn line ->
        regex = ~r/^(?<tone>[a-z]+)\s(?<color>[a-z]+)\s(?<rest>.*)$/
        case Regex.named_captures(regex, line) do
           %{"tone" => tone, "color" => color, "rest" => rest} = _parsed_line ->  %{"tone"=> tone, "color"=>color, "bags" => parse_bag(rest)}
        end
      end)
  end

  def find_rule(rules, bag) do
    rules
      |> Enum.find(fn rule ->
        rule["color"] == bag["color"] && rule["tone"] == bag["tone"]
      end)
  end

  def part1() do
    parse()
      |> (fn rules ->
          Enum.map(rules, fn rule -> bag_contains(rule, %{"tone" => "shiny", "color" => "gold"}, rules)

          end)
  end).()
      |> Enum.count(fn found -> found end)
  end

  def part2() do
    parse()
  end
end


AOC2020Day07.part1() |> IO.inspect
#AOC2020Day07.part2() |> IO.inspect

