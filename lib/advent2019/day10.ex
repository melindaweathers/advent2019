#mix run -e 'Day10.run'
defmodule Day10 do
  require Math

  def load_map(filename) do
    File.stream!(filename)
      |> Stream.map(&(String.trim_trailing(&1,"\n")))
      |> Stream.map(&String.graphemes/1)
      |> Stream.map(&build_map_row/1)
      |> Stream.with_index
      |> Enum.to_list
      |> Enum.map(fn {k,v}->{v,k} end)
      |> Map.new
  end

  def build_map_row(chars) do
    chars |> Enum.with_index |> Enum.map(fn {k,v}->{v,k} end) |> Map.new
  end

  def asteroid_at_slope(map, {x, y}, {run, rise}), do: _asteroid_at_slope(map, {x+run, y+rise}, {run, rise}, map[y+rise][x+run])
  defp _asteroid_at_slope(map, {x, y}, {run, rise}, ".") do
    _asteroid_at_slope(map, {x+run, y+rise}, {run, rise}, map[y+rise][x+run])
  end
  defp _asteroid_at_slope(_map, {x, y}, _slope, "#"), do: {x, y}


  def is_visible_asteroid?(_map, {x, y}, {x, y}, "#"), do: false
  def is_visible_asteroid?(_map, _base, _target, "."), do: false
  def is_visible_asteroid?(map, {xbase, ybase}, {xtarget, ytarget}, "#") do
    slope = { xtarget - xbase, ytarget - ybase } |> reduce_slope
    asteroid_at_slope(map, {xbase, ybase}, slope) == {xtarget, ytarget}
  end

  def reduce_slope({run, rise}) do
    gcd = gcd(abs(run), abs(rise))
    { div(run, gcd), div(rise, gcd) }
  end

  def gcd(0, 0), do: 1
  def gcd(0, y), do: y
  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x,y))

  def count_visible(_map, _, "."), do: 0
  def count_visible(map, base_asteroid, "#") do
    ymax = map_size(map)-1
    xmax = map_size(map[0])-1
    Enum.map(0..ymax, fn(y) ->
      Enum.map(0..xmax, fn(x) ->
        if is_visible_asteroid?(map, base_asteroid, {x, y}, map[y][x]), do: 1, else: 0
      end) |> Enum.sum
    end) |> Enum.sum
  end

  def find_best(map) do
    ymax = map_size(map)-1
    xmax = map_size(map[0])-1
    options = Enum.map(0..ymax, fn(y) ->
      Enum.map(0..xmax, fn(x) ->
        {x, y, count_visible(map, {x, y}, map[y][x])}
      end)
    end) |> List.flatten
    {x, y, count} = Enum.max_by(options, fn {_x, _y, visible} -> visible end)
    IO.inspect("#{x}, #{y}, #{count}")
  end

  def atan({xbase, ybase}, {x, y}), do: Math.atan2(y - ybase, x - xbase)

  def vaporization_candidates(map, {xbase, ybase}, prev_angle) do
    ymax = map_size(map)-1
    xmax = map_size(map[0])-1
    Enum.map(0..ymax, fn(y) ->
      Enum.map(0..xmax, fn(x) ->
        angle = atan({xbase, ybase}, {x, y})
        if angle > prev_angle && is_visible_asteroid?(map, {xbase, ybase}, {x, y}, map[y][x]), do: {x, y, angle}, else: nil
      end)
    end) |> List.flatten |> Enum.reject(&is_nil/1)
  end

  def best_of_candidates([]), do: nil
  def best_of_candidates(candidates), do: Enum.min_by(candidates, fn {_x, _y, angle} -> angle end)

  def next_to_vaporize(map, basepoint, prev_angle) do
    best_candidate = vaporization_candidates(map, basepoint, prev_angle) |> best_of_candidates
    if best_candidate == nil do
      vaporization_candidates(map, basepoint, -1000) |> best_of_candidates
    else
      best_candidate
    end
  end

  def vaporize(map, {x, y, _angle}) do
    Map.put(map, y, Map.put(map[y], x, "."))
  end

  def run_vaporization(map, {xbase, ybase}), do: _run_vaporization(map, {xbase, ybase}, [], atan({xbase, ybase}, {xbase, ybase - 1}) - 0.0000000001)
  defp _run_vaporization(map, basepoint, vaporized, prev_angle) do
    nextpoint = next_to_vaporize(map, basepoint, prev_angle)
    if nextpoint do
      {_, _, angle} = nextpoint
      _run_vaporization(vaporize(map, nextpoint), basepoint, [nextpoint|vaporized], angle)
    else
      vaporized |> Enum.reverse
    end
  end

  def twohundredth(map, basepoint) do
    vaporized = run_vaporization(map, basepoint)
    {x, y, _angle} = Enum.at(vaporized, 199)
    IO.inspect "#{x}, #{y}"
  end


  def run do
    IO.puts "Should be 8"
    IO.puts load_map('inputs/day10-sample.txt') |> find_best

    IO.puts "Should be 33"
    IO.puts load_map('inputs/day10-sample2.txt') |> find_best

    IO.puts "Should be 35"
    IO.puts load_map('inputs/day10-sample3.txt') |> find_best

    IO.puts "Should be 41"
    IO.puts load_map('inputs/day10-sample4.txt') |> find_best

    IO.puts "Should be 210"
    IO.puts load_map('inputs/day10-sample5.txt') |> find_best

    IO.puts "First Star"
    IO.puts load_map('inputs/day10.txt') |> find_best

    IO.puts "Should be 8, 2"
    twohundredth(load_map('inputs/day10-sample5.txt'), {11, 13})

    IO.puts "Second Star"
    twohundredth(load_map('inputs/day10.txt'), {17, 22})
  end
end

