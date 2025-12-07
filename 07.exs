example = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

defmodule Solution do
  def splits?(line, pos) do
    Enum.at(line, pos) == "^"
  end

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
end

IO.write("Part 1: ")
File.read!("input/07.txt")
|> Solution.part1()
|> IO.puts()
