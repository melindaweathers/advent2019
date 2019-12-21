#mix run -e 'Day17.run'
defmodule Day17 do
  require IntCode

  def run do
    {:ok, operations} = File.read("inputs/day17.txt")
    IO.puts IntCode.run_program(operations).outputs

    main_routine = [?C, ?,, ?A, ?,, ?C, ?,, ?B, ?,, ?C, ?,, ?A, ?,, ?B, ?,, ?A, ?,, ?B, ?,, ?A, 10]
    a_function = [?R, ?,, ?8, ?,, ?L, ?,, ?1, ?2, ?,, ?R, ?,, ?4, ?,, ?R, ?,, ?4, 10]
    b_function = [?R, ?,, ?8, ?,, ?L, ?,, ?1, ?0, ?,, ?R, ?,, ?8, 10]
    c_function = [?R, ?,, ?8, ?,, ?L, ?,, ?1, ?0, ?,, ?L, ?,, ?1, ?2, ?,, ?R, ?,, ?4, 10]
    video = [?N, 10]
    inputs = main_routine ++ a_function ++ b_function ++ c_function ++ video
    IO.puts inputs

    {:ok, operations} = File.read("inputs/day17-part2.txt")
    program = IntCode.run_program(operations, inputs)
    IO.puts program.outputs
    IO.inspect List.last(program.outputs)
    IO.puts List.last(program.outputs)
  end
end
