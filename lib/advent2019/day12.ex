#mix run -e 'Day12.run'
defmodule Day12 do
  require IntCode

  def draw_tiles(inputs), do: _draw_tiles(inputs, %{})
  defp _draw_tiles([], tiles), do: tiles
  defp _draw_tiles([x, y, id|tail], tiles) do
    _draw_tiles(tail, Map.put(tiles, "#{x},#{y}", id))
  end

  def count_blocks(tiles) do
    (for block <- Map.values(tiles), block == 2, do: 1) |> Enum.sum
  end

  def run do
    {:ok, operations} = File.read('inputs/day12.txt')
    IO.inspect IntCode.run_program(operations).outputs |> draw_tiles |> count_blocks
  end
end
