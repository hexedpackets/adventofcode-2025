Mix.install([:nx])

defmodule Solution do
  def part1() do
    {data, [ops]} = File.read!("input/06.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split/1)
    |> Enum.split(-1)

    data = Stream.map(data, fn row -> Stream.map(row, &String.to_integer/1) end)

    ops
    |> Stream.with_index()
    |> Enum.sum_by(fn {op, index} ->
      values = data |> Stream.map(fn row -> Enum.at(row, index) end)
      case op do
        "+" -> Enum.sum(values)
        "*" -> Enum.reduce(values, 1, fn n, acc -> n * acc end)
      end
    end)
  end

  def part2() do
    {data, [ops]} = File.read!("input/06.txt")
    |> String.split("\n", trim: true)
    |> Stream.map(fn row -> String.split(row, "") end)
    |> Enum.split(-1)


    {total, _} = ops
    |> Stream.with_index()
    |> Enum.reverse()
    |> Enum.reduce({0, []}, fn {op, index}, {total, acc} ->
      num = data
      |> Stream.map(fn row -> Enum.at(row, index)  end)
      |> Enum.join("")
      |> String.trim()

      values =
        case num do
          "" -> acc
          _ -> [String.to_integer(num) | acc]
        end

      case op do
        "+" ->
          {total + Enum.sum(values), []}

        "*" ->
          answer = Enum.reduce(values, 1, fn n, acc -> n * acc end)
          {answer + total, []}

        " " -> {total, values}
        "" -> {total, values}
      end
    end)

    total
  end
end

IO.write("Part 1: ")
Solution.part1() |> IO.puts()

IO.write("Part 2: ")
Solution.part2() |> IO.inspect()
