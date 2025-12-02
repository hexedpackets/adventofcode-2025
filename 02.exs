defmodule Solution do
  def parse_range(range) do
    range |> String.split("-", parts: 2) |> Enum.map(&String.to_integer/1)
  end

  def find_invalid([first, last], mod) do
    Enum.reduce(first..last, 0, fn id, acc ->
      bin_id = to_string(id)
      if mod.is_invalid?(bin_id) do
        acc + id
      else
        acc
      end
    end)
  end

  defmodule Part1 do
    require Integer

    def is_invalid?(id) do
      size = byte_size(id)
      if Integer.is_odd(size) do
        false
      else
        n = div(size, 2)
        <<chunk::binary-size(n), rest::binary>> = id
        chunk == rest
      end
    end
  end

  defmodule Part2 do
    def is_invalid?(<<_>>), do: false
    def is_invalid?(id) do
      size = byte_size(id)
      n = div(size, 2)
      Enum.reduce_while(1..n, false, fn pos, _ ->
        <<pattern::binary-size(pos), rest::binary>> = id
        case :binary.split(rest, pattern, [:global, :trim_all]) do
          [] -> {:halt, true}
          _ -> {:cont, false}
        end
      end)
    end
  end
end

example = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
|> String.split(",")
|> Stream.map(&Solution.parse_range/1)

IO.write("Example part 1: ")
example
|> Enum.reduce(0, fn range, acc ->
  acc + Solution.find_invalid(range, Solution.Part1)
end)
|> IO.puts()

IO.write("Example part 2: ")
example
|> Enum.reduce(0, fn range, acc ->
  acc + Solution.find_invalid(range, Solution.Part2)
end)
|> IO.puts()

data = IO.read(:line)
|> String.trim()
|> String.split(",")
|> Stream.map(&Solution.parse_range/1)

IO.write("Part 1: ")
data
|> Enum.reduce(0, fn range, acc ->
  acc + Solution.find_invalid(range, Solution.Part1)
end)
|> IO.puts()

IO.write("Part 2: ")
data
|> Enum.reduce(0, fn range, acc ->
  acc + Solution.find_invalid(range, Solution.Part2)
end)
|> IO.puts()
