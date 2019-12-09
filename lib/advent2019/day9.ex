#mix run -e 'Day9.run'
defmodule Day9 do
  require IntCode

  def run do
    {:ok, operations} = File.read('inputs/day9.txt')

    IO.puts "First Star"
    IO.inspect IntCode.run_program(operations, [1]).outputs

  end
end
