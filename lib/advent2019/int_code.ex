defmodule IntCode do
  defmodule Program do
    defstruct instructions: Map.new(), pos: 0, inputs: [], outputs: [], halt: false
  end

  def run_program(str, inputs \\ []) do
    map = parse_instructions(str)
    _run_program(%Program{instructions: map, pos: 0, inputs: inputs, outputs: []})
  end
  defp _run_program(%Program{halt: true} = program) do
    outputs = program.outputs |> Enum.reverse
    %{ program | outputs: outputs }
  end
  defp _run_program(program) do
    { op, param_modes } = parse_op(program.instructions[program.pos])
    run_op(program, op, param_modes) |> _run_program
  end

  def parse_op(op) do
    { rem(op, 100),
      %{1 => rem(div(op,100),10),
        2 => rem(div(op,1000),10),
        3 => rem(div(op,10000),10),
        4 => rem(div(op,100000),10) } }
  end

  def lookup(program, offset, param_modes), do: _lookup(program, offset, param_modes[offset])
  def _lookup(program, offset, 0), do: program.instructions[program.instructions[program.pos + offset]]
  def _lookup(program, offset, 1), do: program.instructions[program.pos + offset]

  def set_val(program, offset, val) do
    set_pos = program.instructions[program.pos + offset]
    new_map = Map.put(program.instructions, set_pos, val)
    %{ program | instructions: new_map }
  end

  def advance(program, offset), do: %{ program | pos: program.pos + offset }

  def set_inputs(program, inputs), do: %{ program | inputs: inputs }

  # Op 99 - Halt
  def run_op(program, 99, _), do: %{ program | halt: true }

  # Op 1 - Add
  def run_op(program, 1, param_modes) do
    add1 = lookup(program, 1, param_modes)
    add2 = lookup(program, 2, param_modes)
    set_val(program, 3, add1 + add2) |> advance(4)
  end

  # Op 2 - Mult
  def run_op(program, 2, param_modes) do
    add1 = lookup(program, 1, param_modes)
    add2 = lookup(program, 2, param_modes)
    set_val(program, 3, add1 * add2) |> advance(4)
  end

  # Op 3 - Read Input
  def run_op(program, 3, _param_modes) do
    [this_input | other_inputs] = program.inputs
    set_val(program, 1, this_input) |> set_inputs(other_inputs) |> advance(2)
  end

  # Op 4 - Output
  def run_op(program, 4, param_modes) do
    output = lookup(program, 1, param_modes)
    %{ program | outputs: [output|program.outputs] } |> advance(2)
  end

  # Op 5 - Jump if true
  def run_op(program, 5, param_modes) do
    check_for_true = lookup(program, 1, param_modes)
    if check_for_true != 0 do
      new_pos = lookup(program, 2, param_modes)
      %{ program | pos: new_pos }
    else
      program |> advance(3)
    end
  end

  # Op 6 - Jump if false
  def run_op(program, 6, param_modes) do
    check_for_false = lookup(program, 1, param_modes)
    if check_for_false == 0 do
      new_pos = lookup(program, 2, param_modes)
      %{ program | pos: new_pos }
    else
      program |> advance(3)
    end
  end

  # Op 7 - less than
  def run_op(program, 7, param_modes) do
    param1 = lookup(program, 1, param_modes)
    param2 = lookup(program, 2, param_modes)
    val = if param1 < param2, do: 1, else: 0
    set_val(program, 3, val) |> advance(4)
  end

  # Op 8 - equals
  def run_op(program, 8, param_modes) do
    param1 = lookup(program, 1, param_modes)
    param2 = lookup(program, 2, param_modes)
    val = if param1 == param2, do: 1, else: 0
    set_val(program, 3, val) |> advance(4)
  end

  def parse_instructions(str) do
    str
    |> String.trim
    |> String.split(",")
    |> Enum.with_index(0)
    |> Enum.map(fn {k,v}->{v, String.to_integer(k)} end)
    |> Map.new
  end

  def get_instructions(program) do
    map = program.instructions
    indices = Map.keys(map) |> Enum.sort
    Enum.map(indices, fn(i) ->
      Map.get(map, i)
    end) |> Enum.join(",")
  end
end
