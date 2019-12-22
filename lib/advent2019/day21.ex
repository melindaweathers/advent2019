#mix run -e 'Day21.run'
defmodule Day21 do
  require IntCode

  def send_commands(commands, program) do
    chars = commands |> Enum.join("\n") |> String.to_charlist
    IO.puts chars
    IntCode.resume_with_inputs(%{ program | outputs: []}, chars)
  end

  def print_output(program) do
    last = List.last(program.outputs)
    if last > 1000 do
      IO.puts List.delete_at(program.outputs, length(program.outputs)-1)
      IO.inspect last
    else
      IO.puts program.outputs
    end
  end

  def first_star(program) do
    ["NOT A J", # Jump if there's no ground right in front
     "OR D J", # Jump if there is ground where I land
     "NOT A T", # Unless there's ground in A, B, and C
     "NOT T T",
     "AND B T",
     "AND C T",
     "NOT T T",
     "AND T J",
     "WALK",""] |> send_commands(program) |> print_output
  end

  def second_star(program) do
    [
     "NOT A J", # Jump if there's no ground in front
     "OR D J", # Jump if there is ground where I land
     "NOT A T", # Unless there's ground in A, B, and C
     "NOT T T",
     "AND B T",
     "AND C T",
     "NOT T T",
     "AND T J",
     "NOT H T", # Unless the second jump will fail
     "NOT T T",
     "OR E T",
     "AND T J",
     "RUN",""] |> send_commands(program) |> print_output
  end

  def run do
    {:ok, operations} = File.read("inputs/day21.txt")
    IntCode.run_program(operations) |> first_star
    IntCode.run_program(operations) |> second_star
  end
end
