#mix run -e 'Day3.run'
defmodule Day3 do
  defmodule Point do
    defstruct distance: 0, x: 0, y: 0
  end

  def find_points(str) do
    directions = String.split(String.trim(str),",")
    _find_points(directions, MapSet.new(), 0, 0)
  end
  defp _find_points([], points, _x, _y), do: points
  defp _find_points([head|directions], points, x, y) do
    {new_points, x, y} = points_for_direction(head, x, y, points)
    _find_points(directions, new_points, x, y)
  end

  def points_for_direction(direction, x, y, points) do
    [dir, distance_str] = String.split(direction, "",trim: true, parts: 2)
    distance = String.to_integer(distance_str)
    _points_for_direction(dir, distance, x, y, points)
  end
  defp _points_for_direction(_, 0, x, y, points), do: {points, x, y}
  defp _points_for_direction(dir, distance, x, y, points) do
    new_point = point_for_direction(dir, x, y)
    _points_for_direction(dir, distance - 1, new_point.x, new_point.y, MapSet.put(points, new_point))
  end

  def point_for_direction("U", x, y), do: %Point{distance: abs(x) + abs(y+1), x: x, y: y + 1}
  def point_for_direction("D", x, y), do: %Point{distance: abs(x) + abs(y-1), x: x, y: y - 1}
  def point_for_direction("L", x, y), do: %Point{distance: abs(x-1) + abs(y), x: x-1, y: y}
  def point_for_direction("R", x, y), do: %Point{distance: abs(x+1) + abs(y), x: x+1, y: y}

  def sort_points(points) do
    Enum.sort(points, fn(point1,point2) -> (point1.distance < point2.distance) end)
  end

  def find_closest(a_points, b_points) do
    intersections = MapSet.intersection(a_points, b_points)
    list = MapSet.to_list(intersections)
    [closest|_] = sort_points(list)
    closest.distance
  end

  def find_closest_from_file(filename) do
    lines = File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&find_points/1)
      |> Enum.to_list
    [points_a, points_b] = lines
    find_closest(points_a, points_b)
  end

  def run do
    IO.puts "Sample 1 - should be 159"
    IO.puts find_closest_from_file('inputs/day3-sample1.txt')

    IO.puts "Sample 2 - should be 135"
    IO.puts find_closest_from_file('inputs/day3-sample2.txt')

    IO.puts "First Star"
    IO.puts find_closest_from_file('inputs/day3.txt')
  end
end
