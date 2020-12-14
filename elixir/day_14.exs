Code.require_file("elixir/utils.exs")
use Bitwise

defmodule AOC2020Day14 do
  def  pow(n, k), do: pow(n, k, 1)
  defp pow(_, 0, acc), do: acc
  defp pow(n, k, acc), do: pow(n, k - 1, n * acc)

  def parse() do
    File.read!("inputs/day-14.puzzle.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn part ->
        regex = ~r/^(?<cmd>.*)\s\=\s(?<value>.+)$/
        case Regex.named_captures(regex, part) do
          %{"cmd" => cmd, "value" => value} = parsed_cmd -> parsed_cmd
          nil -> :empty
        end
      end)
      |> Enum.map(fn instruction ->
        case instruction["cmd"] do
          "mask" -> %{cmd: :mask, value: instruction["value"]}
          _ ->  %{cmd: :write, addr: Regex.named_captures(~r/^mem\[(?<addr>\d+)\]$/, instruction["cmd"])["addr"] |> String.to_integer, value: String.to_integer(instruction["value"])}
        end
      end)
  end

  def parse_bits(bits) do
    String.graphemes(bits)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {bit, idx} ->
        case bit do
          "1" -> :math.pow(2, idx)
          _ -> 0
        end
      end)
      |> Enum.reduce(0, fn v, acc -> v + acc end)
  end

  def to_bits(int) do
    0..35
      |> Enum.map(fn idx ->
        current = pow(2, idx)
        r = current &&& int
        if current == r do
          "1"
        else
          "0"
        end
    end)
      |> Enum.reverse()
      |> Enum.reduce(fn b, acc -> acc <> b end)
  end

  def apply_mask(mask, int) do
    to_bits(int)
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {b, idx} ->
        mask_value = String.at(mask, idx)
        case mask_value do
          "X" -> b
          _ -> mask_value
        end
      end)
      |> Enum.reduce(fn b, acc -> acc <> b end)
      |> parse_bits()
  end


  def part1() do
    instructions = parse()
    memory = %{}

    Enum.reduce(instructions, {nil, memory}, fn instruction, acc ->
      {current_mask, current_memory} = acc
      IO.inspect( {current_mask, current_memory, instruction.cmd})
      case instruction.cmd do
        :mask -> {instruction.value, current_memory}
        :write -> {current_mask, Map.put(current_memory, instruction.addr, apply_mask(current_mask, instruction.value))}
      end
    end)
    |> (fn {mask, memory} -> memory end).()
    |> Map.to_list()
    |> Enum.reduce(0, fn {addr, value}, acc ->
      acc + value
    end)
  end

  def part2() do
    parse()

  end
end


AOC2020Day14.part1() |> IO.inspect
#AOC2020Day14.part2() |> IO.inspect

#AOC2020Day14.parse_bits("101") |> IO.inspect
#AOC2020Day14.to_bits(5) |> IO.inspect

#AOC2020Day14.apply_mask("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 0) |> IO.inspect
