#mix run -e 'Day2.run'
defmodule Day2 do

  def run_program(str) do
    map = str_to_map(str)
    _run_program(map, 0, map[0])
  end
  def _run_program(map, _pos, 99), do: map
  def _run_program(map, pos, 1) do
    new_map = Map.put(map, map[pos + 3], map[map[pos + 1]] + map[map[pos + 2]])
    _run_program(new_map, pos + 4, new_map[pos + 4])
  end
  def _run_program(map, pos, 2) do
    new_map = Map.put(map, map[pos + 3], map[map[pos + 1]] * map[map[pos + 2]])
    _run_program(new_map, pos + 4, new_map[pos + 4])
  end

  def run_with_noun_verb(str, noun, verb) do
    map = str |> String.trim |> str_to_map
    map = Map.put(map, 1, noun)
    map = Map.put(map, 2, verb)
    _run_program(map, 0, map[0])
  end

  def str_to_map(str) do
    String.split(str, ",")
    |> Enum.with_index(0)
    |> Enum.map(fn {k,v}->{v, String.to_integer(k)} end)
    |> Map.new
  end

  def map_to_str(map) do
    indices = Map.keys(map) |> Enum.sort
    Enum.map(indices, fn(i) ->
      Map.get(map, i)
    end) |> Enum.join(",")
  end

  def find_noun_verb(str, target), do: _find_noun_verb(str, target, 0, 0)
  defp _find_noun_verb(str, target, noun, 100), do: _find_noun_verb(str, target, noun + 1, 0)
  defp _find_noun_verb(str, target, noun, verb) do
    result = run_with_noun_verb(str, noun, verb)
    if result[0] == target do
      noun * 100 + verb
    else
      _find_noun_verb(str, target, noun, verb + 1)
    end
  end

  def run do
    IO.puts "First Star"
    {:ok, input} = File.read('inputs/day2.txt')
    first_star_result = run_with_noun_verb(input, 12, 2)
    IO.puts first_star_result[0]

    IO.puts "Second Star"
    expected_output = 19690720
    IO.puts find_noun_verb(input, expected_output)
  end
end
