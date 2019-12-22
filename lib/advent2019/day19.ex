#mix run -e 'Day19.run'
defmodule Day19 do
  require IntCode

  def count_affected_points(program) do
    #load_beams(program, 49) |> print_beams
    load_beams(program, 49) |> List.flatten |> Enum.sum
  end

  def load_beams(program, max) do
    Enum.map(0..max, fn(y) ->
      Enum.map(0..max, fn(x) ->
        IntCode.resume_with_inputs(program, [x, y]).outputs |> List.first
      end)
    end)
  end

  def print_beams(beams) do
    for row <- beams, do: row |> Enum.join |> IO.inspect
  end

  def load_beams_as_map(program, max) do
    Enum.map(0..max, fn(y) ->
      xs = Enum.map(0..max, fn(x) ->
        {x, IntCode.resume_with_inputs(program, [x, y]).outputs |> List.first}
      end)
      {y, Map.new(xs)}
    end) |> Map.new
  end

  def fit_square(program) do
    max = 3000
    square_size = 100
    beams = load_beams_as_map(program, max)
    Enum.map(0..max-square_size, fn(y) ->
      Enum.map(0..max-square_size, fn(x) ->
        if beams[y][x] == 1, do: square_fits_at(beams, x, y, square_size), else: {100000,100000}
      end)
    end) |> List.flatten |> Enum.min_by(fn {x, y} -> x + y end)
  end

  def square_fits_at(beams, x, y, size) do
    if square_fits(beams, x, y, size) == 1, do: {x, y}, else: {100000,100000}
  end
  def square_fits(beams, x, y, size) do
    #Enum.reduce(y..y+size-1, 1, fn y, col ->
      #Enum.reduce(x..x+size-1, 1, fn x, row ->
        #row * beams[y][x]
      #end) * col
    #end)
    beams[y][x]*beams[y+size-1][x+size-1]*beams[y+size-1][x]*beams[y][x+size-1]
  end

  def run do
    {:ok, operations} = File.read("inputs/day19.txt")
    IntCode.run_program(operations) |> count_affected_points |> IO.inspect
    IntCode.run_program(operations) |> fit_square |> IO.inspect
  end
end
