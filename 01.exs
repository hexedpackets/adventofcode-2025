defmodule Solution do
  def bound_dial(d) when d < 0, do: bound_dial(d + 100)
  def bound_dial(d) when d > 99, do: bound_dial(d - 100)
  def bound_dial(d), do: d

  def part_1(<<d, n::binary>>, {count, dial}) do
    n = String.to_integer(n)

    dial =
      case d do
        ?L -> bound_dial(dial - n)
        ?R -> bound_dial(dial + n)
      end

    count = if dial == 0, do: count + 1, else: count
    {count, dial}
  end

  def part_2(<<d, n::binary>>, {count, start}) do
    n = String.to_integer(n)

    total =
      case d do
        ?L -> start - n
        ?R -> start + n
      end

    dial = bound_dial(total)

    cond do
      total == 0 ->
        {count + 1, 0}

      start != 0 and total < 0 ->
        count = count + 1 + (total |> abs() |> div(100))
        {count, dial}

      true ->
        count = count + (total |> abs() |> div(100))
        {count, dial}
    end
  end
end

data = IO.stream(:stdio, :line)
|> Stream.map(fn l -> String.trim(l) end)
|> Stream.take_while(fn l -> l != "" end)
|> Enum.to_list()

IO.write("Part 1: ")
Enum.reduce(data, {0, 50}, &Solution.part_1/2) |> elem(0) |> IO.puts()

IO.write("Part 2: ")
Enum.reduce(data, {0, 50}, &Solution.part_2/2) |> elem(0) |> IO.puts()
