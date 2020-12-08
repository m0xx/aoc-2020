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

  def swap_op(op) do
    case op do
      "acc" -> "acc"
      "nop" -> "jmp"
      "jmp" -> "nop"
    end
  end

  def execute({op, arg}, acc) do
    case op do
      "acc" -> acc + arg
      _ -> acc
    end
  end


  def run(instructions, pointer, accumulator, visited) do
    cond do
      pointer in visited ->
        IO.puts("Breaking out of loop...")
        {:break, accumulator}
      pointer >= length(instructions) ->
        IO.puts("Terminating...")
        {:terminated, accumulator}
      true ->
        {op, arg} = Enum.at(instructions, pointer)
        run(instructions, next_pointer({op, arg}, pointer), execute({op, arg}, accumulator), visited ++ [pointer])
    end
  end


  def boot(instructions, index) do
    {op, arg} = Enum.at(instructions, index)

    {status, acc} = run(List.replace_at(instructions, index, {swap_op(op), arg}), 0, 0, [])
    case status do
      :break ->
        boot(instructions, index + 1)
      :terminated -> acc
    end
  end

  def part1() do
    parse()
    |> (fn instructions ->  run(instructions, 0, 0, []) end).()
  end

  def part2() do
    parse()
    |> (fn instructions ->  boot(instructions, 0) end).()
  end
end


AOC2020Day08.part1() |> IO.inspect
AOC2020Day08.part2() |> IO.inspect
