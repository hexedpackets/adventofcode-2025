defmodule Solution do
  @doc """
  Part 1: two digits to find.
  """
  def find_largest_joltage(bank) do
    bank = bank
    |> String.to_charlist()

    count = Enum.count(bank)

    {first_digit, index} = bank
    |> Stream.take(count - 1)
    |> Stream.with_index()
    |> Enum.max_by(fn {n, _index} -> n end)

    second_digit = bank
    |> Stream.drop(index + 1)
    |> Enum.max()

    {n, []} = :string.to_integer([first_digit, second_digit])
    n
  end

  @doc """
  Part 2: twelve digits.
  """
  def find_largest_joltage(bank, total) do
    find_largest_joltage(bank, total, [])
  end
  def find_largest_joltage(_, 0, acc) do
    {n, []} = acc
    |> Enum.reverse()
    |> :string.to_integer()
    n
  end
  def find_largest_joltage(bank, total, acc) do
    count = Enum.count(bank)
    remaining = total - 1

    {digit, index} = bank
    |> Stream.take(count - remaining)
    |> Stream.with_index()
    |> Enum.max_by(fn {n, _index} -> n end)

    {_, bank} = Enum.split(bank, index + 1)
    find_largest_joltage(bank, remaining, [digit | acc])
  end
end

example = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

IO.write("Example part 1: ")
example
|> String.split("\n", trim: true)
|> Stream.map(&Solution.find_largest_joltage/1)
|> Enum.sum()
|> IO.puts()

IO.write("Part 1: ")
File.read!("input/03.txt")
|> String.split("\n", trim: true)
|> Stream.map(&Solution.find_largest_joltage/1)
|> Enum.sum()
|> IO.puts()

IO.write("Example part 2: ")
example
|> String.split("\n", trim: true)
|> Stream.map(&String.to_charlist/1)
|> Stream.map(fn bank -> Solution.find_largest_joltage(bank, 12) end)
|> Enum.sum()
|> IO.inspect()

IO.write("Part 2: ")
File.read!("input/03.txt")
|> String.split("\n", trim: true)
|> Stream.map(&String.to_charlist/1)
|> Stream.map(fn bank -> Solution.find_largest_joltage(bank, 12) end)
|> Enum.sum()
|> IO.inspect()
