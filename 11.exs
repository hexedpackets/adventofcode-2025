defmodule Solution do
  def count_paths_out(_, "out"), do: 1

  def count_paths_out(devices, device) do
    Map.get(devices, device)
    |> Stream.map(fn next ->
      count_paths_out(devices, next)
    end)
    |> Enum.sum()
  end
end

File.read!("input/11.txt")
|> String.split("\n", trim: true)
|> Stream.map(fn row ->
  [device, outputs] = String.split(row, ": ", parts: 2)
  outputs = String.split(outputs, " ")
  {device, outputs}
end)
|> Map.new()
|> Solution.count_paths_out("you")
|> IO.puts()
