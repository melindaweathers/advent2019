#mix run -e 'Day7.run'
defmodule Day7 do
  require IntCode
  require Permutations

  def check_sequence([aphase, bphase, cphase, dphase, ephase], operations) do
    a = IntCode.run_program(operations, [aphase])
    b = IntCode.run_program(operations, [bphase])
    c = IntCode.run_program(operations, [cphase])
    d = IntCode.run_program(operations, [dphase])
    e = IntCode.run_program(operations, [ephase])
    run_feedback_loop([a,b,c,d,e], 0, false)
  end
  def run_feedback_loop(_programs, to_thrusters, true), do: to_thrusters
  def run_feedback_loop([a,b,c,d,e], to_thrusters, false) do
    {a1, a1out} = IntCode.resume_with_inputs(a, [to_thrusters]) |> shift_output
    {b1, b1out} = IntCode.resume_with_inputs(b, [a1out]) |> shift_output
    {c1, c1out} = IntCode.resume_with_inputs(c, [b1out]) |> shift_output
    {d1, d1out} = IntCode.resume_with_inputs(d, [c1out]) |> shift_output
    {e1, e1out} = IntCode.resume_with_inputs(e, [d1out]) |> shift_output
    run_feedback_loop([a1,b1,c1,d1,e1], e1out, a1.halt)
  end

  def shift_output(program) do
    [first_output|remaining] = program.outputs
    { %{ program | outputs: remaining }, first_output }
  end

  def find_best_sequence(operations, sequence_digits) do
    sequences = Permutations.of(sequence_digits)
    Enum.map(sequences, fn(sequence) ->
      check_sequence(sequence, operations)
    end) |> Enum.max
  end

  def run do
    {:ok, operations} = File.read('inputs/day7.txt')
    IO.inspect Day7.find_best_sequence(operations, [0,1,2,3,4])
    IO.inspect Day7.find_best_sequence(operations, [5,6,7,8,9])
  end
end
