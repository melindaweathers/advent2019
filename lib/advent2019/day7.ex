#mix run -e 'Day7.run'
defmodule Day7 do
  require IntCode

  def check_sequence(sequence, operations) do
    [aphase, bphase, cphase, dphase, ephase] = sequence
    a = IntCode.run_program(operations, [aphase, 0])
    b = IntCode.run_program(operations, [bphase, List.first(a.outputs)])
    c = IntCode.run_program(operations, [cphase, List.first(b.outputs)])
    d = IntCode.run_program(operations, [dphase, List.first(c.outputs)])
    e = IntCode.run_program(operations, [ephase, List.first(d.outputs)])
    List.first(e.outputs)
  end

  def get_digits(sequence) do
    [rem(div(sequence,10000),10), rem(div(sequence,1000),10), rem(div(sequence,100),10), rem(div(sequence,10),10), rem(sequence,10)]
  end

  def find_best_sequence(operations) do
    sequences = shuffle([0,1,2,3,4])
    Enum.map(sequences, fn(sequence) ->
      check_sequence(sequence, operations)
    end) |> Enum.max
  end

  # https://stackoverflow.com/questions/33756396/how-can-i-get-permutations-of-a-list
  def shuffle([]), do: [[]]
  def shuffle(list) do
    for h <- list, t <- shuffle(list -- [h]), do: [h | t]
  end

  def run do
    {:ok, operations} = File.read('inputs/day7.txt')

    IO.puts "Sample (43210)"
    IO.inspect Day7.find_best_sequence("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")

    IO.puts "Sample (54321)"
    IO.inspect Day7.find_best_sequence("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")

    IO.puts "Sample (65210)"
    IO.inspect Day7.find_best_sequence("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")

    IO.puts "First Star"
    IO.inspect Day7.find_best_sequence(operations)
  end
end
