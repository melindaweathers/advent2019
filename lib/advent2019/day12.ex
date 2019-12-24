#mix run -e 'Day12.run'
defmodule Day12 do

  defmodule Moon do
    defstruct xpos: 0, ypos: 0, zpos: 0, xvel: 0, yvel: 0, zvel: 0, name: "Io"
  end

  def sample_moons do
    %{ 0 => %Moon{name: "Io", xpos: -1, ypos: 0, zpos: 2},
      1 => %Moon{name: "Europa", xpos: 2, ypos: -10, zpos: -7},
      2 => %Moon{name: "Callisto", xpos: 4, ypos: -8, zpos: 8},
      3 => %Moon{name: "Ganymede", xpos: 3, ypos: 5, zpos: -1} }
  end

  def puzzle_moons do
    %{ 0 => %Moon{name: "Io", xpos: -6, ypos: -5, zpos: -8},
      1 => %Moon{name: "Europa", xpos: 0, ypos: -3, zpos: -13},
      2 => %Moon{name: "Callisto", xpos: -15, ypos: 10, zpos: -11},
      3 => %Moon{name: "Ganymede", xpos: -3, ypos: -8, zpos: 3} }
  end

  def run_step(moons) do
    moons
    |> apply_gravity
    |> apply_velocity
  end

  def run_n_steps(moons, 0), do: moons
  def run_n_steps(moons, n), do: run_n_steps(moons |> run_step, n - 1)

  def apply_gravity(moons) do
    _apply_gravity(moons, [[0,1],[0,2],[0,3],[1,2],[1,3],[2,3]])
  end
  defp _apply_gravity(moons, []), do: moons
  defp _apply_gravity(moons, [[idx1,idx2]|tail]) do
    moon1 = moons[idx1]
    moon2 = moons[idx2]
    moon1 = %{ moon1 | xvel: moon1.xvel + sign(moon2.xpos - moon1.xpos), yvel: moon1.yvel + sign(moon2.ypos - moon1.ypos), zvel: moon1.zvel + sign(moon2.zpos - moon1.zpos) }
    moon2 = %{ moon2 | xvel: moon2.xvel + sign(moon1.xpos - moon2.xpos), yvel: moon2.yvel + sign(moon1.ypos - moon2.ypos), zvel: moon2.zvel + sign(moon1.zpos - moon2.zpos) }
    _apply_gravity(moons |> Map.put(idx1, moon1) |> Map.put(idx2, moon2), tail)
  end

  def apply_velocity(moons) do
    (for i <- 0..3, do: {i, apply_single_velocity(moons[i])}) |> Map.new
  end
  def apply_single_velocity(moon), do: %{ moon | xpos: moon.xpos + moon.xvel, ypos: moon.ypos + moon.yvel, zpos: moon.zpos + moon.zvel }

  def total_energy(moons) do
    Enum.reduce(0..map_size(moons)-1, 0, fn i, energy -> energy + (abs(moons[i].xpos) + abs(moons[i].ypos) + abs(moons[i].zpos))*(abs(moons[i].xvel) + abs(moons[i].yvel) + abs(moons[i].zvel)) end)
  end

  def sign(0), do: 0
  def sign(a) when a < 0, do: -1
  def sign(a) when a > 0, do: 1

  def run do
    sample_moons |> run_n_steps(10) |> total_energy |> IO.inspect
    IO.puts "First Star:"
    puzzle_moons |> run_n_steps(1000) |> total_energy |> IO.inspect
  end
end
