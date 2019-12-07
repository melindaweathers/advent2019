#mix run -e 'Day6.run'
defmodule Day6 do
  defmodule Planet do
    defstruct name: '', parent_name: nil
  end

  def load_file(filename) do
    lines = File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&(String.split(&1,")")))
      |> Enum.to_list
    build_orbits(lines)
  end

  def build_orbits(planets) do
    first_planet = %Planet{name: "COM"}
    universe = %{first_planet.name => first_planet}
    _build_orbits(planets, universe)
  end
  defp _build_orbits([], universe), do: universe
  defp _build_orbits([[first_name, this_name]|remaining], universe) do
    this_planet = %Planet{name: this_name, parent_name: first_name}
    _build_orbits(remaining, Map.put(universe, this_name, this_planet))
  end

  def print_universe(universe) do
    Enum.map(universe, fn({name, planet}) ->
      IO.inspect name
      IO.inspect planet
    end)
  end
  def count_orbits(universe) do
    #print_universe(universe)
    Enum.map(universe, fn({_name, planet}) ->
      count_orbits_for_planet(planet.parent_name, universe)
    end) |> Enum.sum
  end
  def count_orbits_for_planet(nil, _universe), do: 0
  def count_orbits_for_planet(planet_name, universe) do
    planet = universe[planet_name]
    1 + count_orbits_for_planet(planet.parent_name, universe)
  end

  def run do
    sample_universe = load_file('inputs/day6-sample.txt')
    IO.puts "Sample 1 (should be 42)"
    IO.puts count_orbits(sample_universe)

    universe = load_file('inputs/day6.txt')
    IO.puts "First Star"
    IO.puts count_orbits(universe)
  end
end
