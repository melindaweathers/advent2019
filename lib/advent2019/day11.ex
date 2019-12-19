#mix run -e 'Day11.run'
defmodule Day11 do
  require IntCode

  def run_robot(operations, start_color) do
    program = IntCode.run_program(operations, [start_color])
    _run_robot(program, %{}, 0, 0, "U")
  end
  defp _run_robot(%IntCode.Program{halt: true}, panels, _x, _y, _direction), do: panels
  defp _run_robot(program, panels, x, y, direction) do
    {newpanels, newx, newy, newdir} = update_panels(program.outputs, panels, x, y, direction)
    newprogram = IntCode.resume_with_inputs(%{ program | outputs: [] }, [find_color(newpanels, newx, newy)])
    _run_robot( newprogram, newpanels, newx, newy, newdir )
  end

  def update_panels(outputs, panels, x, y, direction) do
    [new_color, turn_direction] = outputs
    {xnew, ynew, dirnew} = move_and_turn(x, y, direction, turn_direction)
    {put_color(panels, x, y, new_color), xnew, ynew, dirnew}
  end

  def move_and_turn(x, y, "U", 0), do: {x-1, y, "L"}
  def move_and_turn(x, y, "U", 1), do: {x+1, y, "R"}
  def move_and_turn(x, y, "R", 0), do: {x, y-1, "U"}
  def move_and_turn(x, y, "R", 1), do: {x, y+1, "D"}
  def move_and_turn(x, y, "D", 0), do: {x+1, y, "R"}
  def move_and_turn(x, y, "D", 1), do: {x-1, y, "L"}
  def move_and_turn(x, y, "L", 0), do: {x, y+1, "D"}
  def move_and_turn(x, y, "L", 1), do: {x, y-1, "U"}

  def find_color(panels, x, y) do
    Map.get(panels, "#{x},#{y}", 0)
  end

  def find_char(panels, x, y) do
    if find_color(panels, x, y) == 0, do: '.', else: '#'
  end

  def put_color(panels, x, y, color) do
    Map.put(panels, "#{x},#{y}", color)
  end

  def count_painted(panels) do
    map_size(panels)
  end

  def show_message(panels) do
    [xmin, xmax, ymin, ymax] = [-10,50,-5,10]
    Enum.map(ymin..ymax, fn(y) ->
      row = Enum.map(xmin..xmax, fn(x) ->
        "#{find_char(panels, x, y)}"
      end) |> Enum.join("")
      IO.inspect row
    end)
  end

  def run do
    {:ok, operations} = File.read('inputs/day11.txt')
    IO.inspect "First Star"
    IO.inspect run_robot(operations, 0) |> count_painted

    IO.inspect "Second Star"
    run_robot(operations, 1) |> show_message
  end
end
