#mix run -e 'Day1.run'
defmodule Day1 do
  def calc_fuel(mass) when mass < 9, do: 0
  def calc_fuel(mass) do
    div(mass, 3) - 2
  end

  def calc_total_fuel(filename) do
    File.stream!(filename)
      |> Stream.map( &( calc_fuel(&1 |> String.trim() |> String.to_integer) ) )
      |> Enum.sum
  end


  def calc_recursive_fuel(0), do: 0
  def calc_recursive_fuel(mass) do
    fuel = calc_fuel(mass)
    fuel + calc_recursive_fuel(fuel)
  end

  def calc_total_recursive_fuel(filename) do
    File.stream!(filename)
      |> Stream.map( &( calc_recursive_fuel(&1 |> String.trim() |> String.to_integer) ) )
      |> Enum.sum
  end

  def run do
    IO.puts "Hello world"

    IO.puts "Should be 34241"
    IO.puts calc_total_fuel('inputs/day1-sample.txt')

    IO.puts "First star"
    IO.puts calc_total_fuel('inputs/day1.txt')

    IO.puts "Should be 2"
    IO.puts calc_recursive_fuel(14)

    IO.puts "Should be 966"
    IO.puts calc_recursive_fuel(1969)

    IO.puts "Should be 50346"
    IO.puts calc_recursive_fuel(100756)

    IO.puts "Second star"
    IO.puts calc_total_recursive_fuel('inputs/day1.txt')
  end
end
