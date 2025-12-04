Mix.install([:nx])

defmodule Solution do
  def create_tensor(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> to_charlist()
      |> Enum.map(fn ?. -> 0; ?@ -> 1 end)
    end)
    |> Nx.tensor()
  end

  def find_rolls(t) do
    t
    |> Nx.window_sum({3, 3}, padding: :same)
    |> Nx.less(5)
    |> Nx.logical_and(t)
  end

  def find_and_remove_rolls(t, total \\ 0) do
    next = find_rolls(t)
    count = count_rolls(next)
    if count > 0 do
      t
      |> Nx.logical_xor(next)
      |> find_and_remove_rolls(total + count)
    else
      total
    end
  end

  def count_rolls(t) do
    t
    |> Nx.sum()
    |> Nx.to_number()
  end
end

_example = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

t = File.read!("input/04.txt")
|> Solution.create_tensor()

IO.write("Part 1: ")
t
|> Solution.find_rolls()
|> Solution.count_rolls()
|> IO.puts()

IO.write("Part 2: ")
t
|> Solution.find_and_remove_rolls()
|> IO.puts()
