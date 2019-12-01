#mix run -e 'Day1.run'
defmodule Day1 do
  def calc_fuel(mass) when mass < 9, do: 0
  def calc_fuel(mass) do
    div(mass, 3) - 2
  end

  def calc_recursive_fuel(0), do: 0
  def calc_recursive_fuel(mass) do
    fuel = calc_fuel(mass)
    fuel + calc_recursive_fuel(fuel)
  end

  def calc_file(filename, fun) do
    File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.to_integer/1)
      |> Stream.map(fun)
      |> Enum.sum
  end

  def run do
    IO.puts "Hello world"

    IO.puts "First star"
    IO.puts calc_file('inputs/day1.txt', &calc_fuel/1)

    IO.puts "Second star"
    IO.puts calc_file('inputs/day1.txt', &calc_recursive_fuel/1)
  end
end
