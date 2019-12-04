#mix run -e 'Day3.run'
defmodule Day3 do
  defmodule Point do
    defstruct distance: 0, x: 0, y: 0
  end

  def find_points(str) do
    directions = String.split(String.trim(str),",")
    _find_points(directions, Map.new(), 0, 0, 0)
  end
  defp _find_points([], points, _x, _y, _step), do: points
  defp _find_points([head|directions], points, x, y, step) do
    {new_points, x, y, step} = points_for_direction(head, x, y, points, step)
    _find_points(directions, new_points, x, y, step)
  end

  def points_for_direction(direction, x, y, points, step) do
    [dir, distance_str] = String.split(direction, "",trim: true, parts: 2)
    distance = String.to_integer(distance_str)
    _points_for_direction(dir, distance, x, y, points, step)
  end
  defp _points_for_direction(_, 0, x, y, points, step), do: {points, x, y, step}
  defp _points_for_direction(dir, distance, x, y, points, step) do
    new_point = point_for_direction(dir, x, y)
    new_map = Map.put(points, new_point, min(step + 1, Map.get(points, new_point, 100000000000000)))
    _points_for_direction(dir, distance - 1, new_point.x, new_point.y, new_map, step + 1)
  end

  def point_for_direction("U", x, y), do: %Point{distance: abs(x) + abs(y+1), x: x, y: y + 1}
  def point_for_direction("D", x, y), do: %Point{distance: abs(x) + abs(y-1), x: x, y: y - 1}
  def point_for_direction("L", x, y), do: %Point{distance: abs(x-1) + abs(y), x: x-1, y: y}
  def point_for_direction("R", x, y), do: %Point{distance: abs(x+1) + abs(y), x: x+1, y: y}

  def sort_points(points) do
    Enum.sort(points, fn(point1,point2) -> (point1.distance < point2.distance) end)
  end

  def find_closest(a_points, b_points) do
    intersections = MapSet.intersection(MapSet.new(Map.keys(a_points)), MapSet.new(Map.keys(b_points)))
    list = MapSet.to_list(intersections)
    [closest|_] = sort_points(list)
    closest.distance
  end

  def find_closest_by_steps(a_points, b_points) do
    intersections = MapSet.intersection(MapSet.new(Map.keys(a_points)), MapSet.new(Map.keys(b_points)))
    Enum.map(MapSet.to_list(intersections), fn(point) ->
      a_points[point] + b_points[point]
    end) |> Enum.min
  end

  def find_closest_from_file(filename, fun) do
    lines = File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&find_points/1)
      |> Enum.to_list
    [points_a, points_b] = lines
    fun.(points_a, points_b)
  end

  def run do
    IO.puts "Sample 1 - should be 159"
    IO.puts find_closest_from_file('inputs/day3-sample1.txt', &find_closest/2)

    IO.puts "Sample 2 - should be 135"
    IO.puts find_closest_from_file('inputs/day3-sample2.txt', &find_closest/2)

    IO.puts "First Star"
    IO.puts find_closest_from_file('inputs/day3.txt', &find_closest/2)

    IO.puts "Sample 1 - should be 610"
    IO.puts find_closest_from_file('inputs/day3-sample1.txt', &find_closest_by_steps/2)

    IO.puts "Sample 2 - should be 410"
    IO.puts find_closest_from_file('inputs/day3-sample2.txt', &find_closest_by_steps/2)

    IO.puts "Second Star"
    IO.puts find_closest_from_file('inputs/day3.txt', &find_closest_by_steps/2)
  end
end
