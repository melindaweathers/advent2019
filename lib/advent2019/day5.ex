#mix run -e 'Day5.run'
defmodule Day5 do
  require IntCode

  def run do
    {:ok, operations} = File.read('inputs/day5.txt')

    IO.puts "First Star"
    IO.inspect IntCode.run_program(operations, [1]).outputs

    IO.puts "Second Star"
    IO.inspect IntCode.run_program(operations, [5]).outputs
  end
end
