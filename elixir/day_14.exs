Code.require_file("elixir/utils.exs")
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

  def apply_mask_v2(mask, int) do
    to_bits(int)
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {b, idx} ->
      mask_value = String.at(mask, idx)
      case mask_value do
        "X" -> "X"
        "0" -> b
        _ -> mask_value
      end
    end)
  end


  def part1() do
    instructions = parse()
    memory = %{}

    Enum.reduce(instructions, {nil, memory}, fn instruction, acc ->
      {current_mask, current_memory} = acc
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

  def get_memory_addresses(mask, addr) do
    bits = apply_mask_v2(mask, addr)

    floating_count = Enum.filter(bits, fn b -> b == "X" end) |> Enum.count()
    floating_bits_comb = combinaisons(floating_count, ["0", "1"])

    floating_bits_comb
      |> Enum.map(fn comb ->
        Enum.reduce(comb, bits, fn b, acc ->
            idx = Enum.find_index(acc, fn l -> l == "X" end)
            List.replace_at(acc, idx, b)
        end)
      end)
      |> Enum.map(fn memory_bits -> Enum.reduce(memory_bits, fn b, acc -> acc <> b end)  end)
      |> Enum.map(&parse_bits/1)
  end


  def update_memory_v2(memory, addr, mask, value) do
    mem_value = value

    get_memory_addresses(mask, addr)
      |> Enum.reduce(memory, fn int_addr, acc ->
        Map.put(acc, int_addr, mem_value)
    end)
  end

  def part2() do
    instructions = parse()
    memory = %{}

    Enum.reduce(instructions, {nil, memory}, fn instruction, acc ->
      {current_mask, current_memory} = acc
      case instruction.cmd do
        :mask -> {instruction.value, current_memory}
        :write -> {current_mask, update_memory_v2(current_memory, instruction.addr, current_mask, instruction.value)}
        _ -> IO.puts('oops')
      end
    end)
    |> (fn {mask, memory} -> memory end).()
    |> Map.to_list()
    |> Enum.reduce(0, fn {addr, value}, acc ->
      acc + value
    end)
  end

  def combinaisons(size, values, acc, results) when is_list(acc) and length(acc) == size, do: results ++ [acc]
  def combinaisons(size, values, acc, results), do: Enum.reduce(values, results, fn value, result ->
    combinaisons(size, values, acc ++ [value], result)
  end)
  def combinaisons(size, values), do: combinaisons(size, values, [], [])
end



#AOC2020Day14.part1() |> IO.inspect
#AOC2020Day14.part2() |> IO.inspect
map = PuzzleMap.init_map(2,3,nil) |> PuzzleMap.rows() |> IO.inspect

Map.get(map, %Point{x: 2, y: 2})

