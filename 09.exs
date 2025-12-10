defmodule Solution do
  def area([x1, y1], [x2, y2]) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def find_largest_area(points) do
    [{_, _, area} | _] = map_to_areas(points, [])
    area
  end

  def map_to_areas([_point], acc) do
    Enum.sort_by(acc, fn {_, _, area} -> area end, :desc)
  end
  def map_to_areas([point | points], acc) do
    acc = acc ++ Enum.map(points, fn other ->
      {point, other, area(point, other)}
    end)

    map_to_areas(points, acc)
  end
end

points = File.read!("input/09-example.txt")
|> String.split("\n", trim: true)
|> Enum.map(fn row ->
  row
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
end)

IO.write("Part 1: ")
points
|> Solution.find_largest_area()
|> IO.puts()
