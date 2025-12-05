defmodule Solution do
  def parse(input) do
    [fresh, available] = String.split(input, "\n\n")

    available = String.split(available)
    |> Enum.map(&String.to_integer/1)

    fresh = String.split(fresh)
    |> Enum.map(fn r ->
      [low, high] = String.split(r, "-")
      |> Enum.map(&String.to_integer/1)
      low..high
    end)

    {fresh, available}
  end

  def count_available(fresh, available) do
    Enum.count(available, fn id ->
      Enum.any?(fresh, fn range -> Enum.member?(range, id) end)
    end)
  end

  def count_fresh(fresh) do
    {clamped, _} = fresh
    |> Enum.sort()
    |> Enum.map_reduce(0..0, fn range, last_range ->
      cond do
        last_range.last >= range.last ->
          # Last range fully contains this one
          {[], last_range}

        range.first <= last_range.last ->
          # Clamp the start of the range to avoid double-counting
          first = last_range.last + 1
          if first > range.last do
            dbg range
            dbg last_range
          end
          range = first..range.last
          {range, range}

        true ->
          {range, range}
      end
    end)

    Enum.sum_by(clamped, fn range ->
      Enum.count(range)
    end)
  end

  def count_fresh_bf(fresh) do
    fresh
    |> Enum.reduce(MapSet.new(), fn range, acc ->
      Enum.reduce(range, acc, fn i, acc ->
        MapSet.put(acc, i)
      end)
    end)
    |> MapSet.size()
  end
end

_example = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""
{fresh, available} = File.read!("input/05.txt") |> Solution.parse()

IO.write("Part 1: ")
Solution.count_available(fresh, available) |> IO.puts()

IO.write("Part 2: ")
Solution.count_fresh(fresh) |> IO.puts()
