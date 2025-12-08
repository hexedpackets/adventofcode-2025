defmodule Solution do
  def calc_distance(point1, point2) do
    Enum.zip(point1, point2)
    |> Stream.map(fn {p1, p2} -> p1 - p2 end)
    |> Stream.map(fn p -> Integer.pow(p, 2) end)
    |> Enum.sum()
    |> :math.sqrt()
  end

  def calc_all_distances([_point], acc) do
    Enum.sort_by(acc, fn {_, _, distance} -> distance end)
  end
  def calc_all_distances([point | boxes], acc) do
    distances = Enum.map(boxes, fn box ->
      distance = calc_distance(point, box)
      {point, box, distance}
    end)
    acc = distances ++ acc
    calc_all_distances(boxes, acc)
  end

  def connect(_, 0, acc), do: acc
  def connect([{p1, p2, _} | distances], count, acc) do
    circuits = Stream.with_index(acc)

    match1 = Enum.find(circuits, fn {set, _} -> MapSet.member?(set, p1) end)
    match2 = Enum.find(circuits, fn {set, _} -> MapSet.member?(set, p2) end)

    acc =
      case {match1, match2} do
        {nil, nil} ->
          [MapSet.new([p1, p2]) | acc]

        {nil, {circuit, index}} ->
          circuit = MapSet.put(circuit, p1)
          List.replace_at(acc, index, circuit)

        {{circuit, index}, nil} ->
          circuit = MapSet.put(circuit, p2)
          List.replace_at(acc, index, circuit)

        {{_, index}, {_, index}} ->
          acc

        {{circuit1, index1}, {circuit2, index2}} ->
          circuit = MapSet.union(circuit1, circuit2)
          acc
          |> List.replace_at(index1, circuit)
          |> List.delete_at(index2)
      end

    connect(distances, count - 1, acc)
  end

  def connect_all([], {_, {[x1, _, _], [x2, _, _]}}) do
    x1 * x2
  end
  def connect_all([{p1, p2, _} | distances], {acc, last_points}) do
    circuits = Stream.with_index(acc)

    match1 = Enum.find(circuits, fn {set, _} -> MapSet.member?(set, p1) end)
    match2 = Enum.find(circuits, fn {set, _} -> MapSet.member?(set, p2) end)

    acc =
      case {match1, match2} do
        {nil, nil} ->
          {[MapSet.new([p1, p2]) | acc], {p1, p2}}

        {nil, {circuit, index}} ->
          circuit = MapSet.put(circuit, p1)
          acc = List.replace_at(acc, index, circuit)
          {acc, {p1, p2}}

        {{circuit, index}, nil} ->
          circuit = MapSet.put(circuit, p2)
          acc = List.replace_at(acc, index, circuit)
          {acc, {p1, p2}}

        {{_, index}, {_, index}} ->
          {acc, last_points}

        {{circuit1, index1}, {circuit2, index2}} ->
          circuit = MapSet.union(circuit1, circuit2)
          acc = acc
          |> List.replace_at(index1, circuit)
          |> List.delete_at(index2)
          {acc, {p1, p2}}
      end

    connect_all(distances, acc)
  end

  def mult_size(circuits, count) do
    circuits
    |> Stream.map(fn set -> MapSet.size(set) end)
    |> Enum.sort(:desc)
    |> Stream.take(count)
    |> Enum.reduce(1, fn i, acc -> i * acc end)
  end
end

boxes = File.read!("input/08.txt")
|> String.split("\n", trim: true)
|> Enum.map(fn row ->
  row
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
end)
|> Solution.calc_all_distances([])

IO.write("Part 1: ")
boxes
|> Solution.connect(1000, [])
|> Solution.mult_size(3)
|> IO.puts()

IO.write("Part 2: ")
boxes
|> Solution.connect_all({[], nil})
|> IO.inspect()
