defmodule Solution do
  def check_split(line, pos, max_pos) do
    if Enum.at(line, pos) == "^" do
      pos1 = max(0, pos - 1)
      pos2 = min(max_pos, pos + 1)
      {pos1, pos2}
    else
      nil
    end
  end

  def part1(input) do
    {[start], data} = input
    |> String.split("\n", trim: true)
    |> Stream.map(fn row -> String.split(row, "", trim: true) end)
    |> Enum.split(1)

    start_pos = Enum.find_index(start, fn c -> c == "S" end)
    max_pos = Enum.count(start) - 1

    {_, splits} =
      Enum.reduce(data, {[start_pos], 0}, fn row, {beams, total} ->
        {new_beams, splits} =
          Enum.reduce(beams, {[], total}, fn pos, {acc, splits} ->
            case check_split(row, pos, max_pos) do
              nil -> {[pos | acc], splits}
              {pos1, pos2} -> {[pos1, pos2 | acc], splits + 1}
            end
          end)
        {Enum.uniq(new_beams), splits}
      end)
    splits
  end

  def part2(input) do
    {[start], data} = input
    |> String.split("\n", trim: true)
    |> Stream.map(fn row -> String.split(row, "", trim: true) end)
    |> Enum.split(1)

    start_pos = Enum.find_index(start, fn c -> c == "S" end)

    data
    |> Stream.map(fn row ->
      row
      |> Stream.with_index()
      |> Stream.filter(fn {c, _} -> c == "^" end)
      |> Enum.map(fn {_, index} -> index end)
    end)
    |> Stream.reject(&Enum.empty?/1)
    |> Enum.with_index()
    |> count_splits(start_pos, {Map.new(), 0})
    |> elem(1)
  end

  def count_splits([], _pos, {acc, _}), do: {acc, 1}
  def count_splits([{row, row_i} | rows], parent_split, {acc, count}) do
    case Enum.find(row, fn index -> index == parent_split end) do
      nil -> count_splits(rows, parent_split, {acc, count})

      index ->
        key = {row_i, index}
        case Map.get(acc, key) do
          nil ->
            {acc, total_left} = count_splits(rows, index - 1, {acc, 0})
            {acc, total_right} = count_splits(rows, index + 1, {acc, 0})
            total = total_left + total_right
            acc = Map.put(acc, key, total)
            {acc, total}

          count -> {acc, count}
        end
    end
  end
end

IO.write("Part 1: ")
File.read!("input/07.txt")
|> Solution.part1()
|> IO.puts()

IO.write("Part 2: ")
File.read!("input/07.txt")
|> Solution.part2()
|> IO.inspect()
