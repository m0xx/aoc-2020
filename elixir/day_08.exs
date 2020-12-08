defmodule AOC2020Day08 do

  def parse() do
    File.read!("inputs/day-08.puzzle.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->  String.split(row, " ") end)
      |> Enum.map(fn [op, arg] -> {op, String.to_integer(arg)} end)
  end

  def next_pointer({op, arg}, pointer) do
    case op do
      "acc" -> pointer + 1
      "jmp" -> pointer + arg
      "nop" -> pointer + 1
    end
  end

  def execute({op, arg}, acc) do
    # TODO: rest operator??
    case op do
      "acc" -> acc + arg
      "nop" -> acc
      "jmp" -> acc
    end
  end

#  def run({op, arg}, pointer, accumulator, history) when {op, arg} in history do
#    IO.puts("Breaking out of loop...")
#    accumulator
#  end

  def run(instructions, pointer, accumulator, visited) do
    {op, arg} = Enum.at(instructions, pointer)
    IO.inspect({op, arg})
    IO.puts(accumulator)

    cond pointer do
      pointer in visited ->
        IO.puts("Breaking out of loop...")
        {:break, accumulator}
      pointer >= len(instructions)
         {:terminated, accumulator}
      _ -> run(instructions, next_pointer({op, arg}, pointer), execute({op, arg}, accumulator), visited ++ [pointer])
    end
  end

  def part1() do
    parse()
    |> (fn instructions ->  run(instructions, 0, 0, []) end).()
  end

  def part2() do
    parse()
  end
end


AOC2020Day08.part1() |> IO.inspect
#AOC2020Day08.part2() |> IO.inspect
