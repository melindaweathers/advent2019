#mix run -e 'Day13.run'
defmodule Day13 do
  require IntCode

  def draw_tiles(inputs), do: _draw_tiles(inputs, %{}, 0)
  defp _draw_tiles([], tiles, score), do: {tiles, score, count_blocks(tiles)}
  defp _draw_tiles([-1, 0, score|tail], tiles, _score), do: _draw_tiles(tail, tiles, score)
  defp _draw_tiles([x, y, id|tail], tiles, score), do: _draw_tiles(tail, Map.put(tiles, "#{x},#{y}", id), score)

  def count_blocks(tiles) do
    (for block <- Map.values(tiles), block == 2, do: 1) |> Enum.sum
  end

  def play_game(program) do
    _play_game(program, -1, draw_tiles(program.outputs))
  end
  defp _play_game(_program, _input, {_tiles, score, 0}), do: IO.inspect score
  defp _play_game(program, input, {tiles, score, _blocks}) do
    new_program = IntCode.resume_with_inputs(%{ program | outputs: [] }, [input])
    {new_tiles, new_score, new_blocks} = _draw_tiles(new_program.outputs, tiles, score)
    #print_board({new_tiles, new_score, new_blocks})
    #IO.gets "Next?"
    _play_game(new_program, next_input(new_tiles), {new_tiles, new_score, new_blocks})
  end

  def print_board({tiles, score, blocks}) do
    IO.inspect("Score: #{score} Blocks: #{blocks}")
    [xmin, xmax, ymin, ymax] = [0,50,0,25]
    Enum.map(ymin..ymax, fn(y) ->
      row = Enum.map(xmin..xmax, fn(x) ->
        key = "#{x},#{y}"
        "#{Map.get(tiles, key)}"
      end) |> Enum.join("")
      IO.inspect row
    end)
  end

  def next_input(tiles) do
    {ball_x, _} = ball_pos(tiles)
    {x, _} = paddle_pos(tiles)
    ball_x - x
  end

  def ball_pos(tiles) do
    tiles |> Enum.find(fn {key, val} -> val == 4 end) |> elem(0) |> to_coords
  end

  def paddle_pos(tiles) do
    tiles |> Enum.find(fn {key, val} -> val == 3 end) |> elem(0) |> to_coords
  end

  def to_coords(key_string) do
    [xstr, ystr] = String.split(key_string, ",")
    {String.to_integer(xstr), String.to_integer(ystr)}
  end

  def run do
    {:ok, operations} = File.read('inputs/day13.txt')
    {_, _, blocks} = IntCode.run_program(operations).outputs |> draw_tiles
    IO.inspect "First Star: #{blocks}"

    {:ok, operations} = File.read('inputs/day13-part2.txt')
    IntCode.run_program(operations) |> play_game
  end
end
