defmodule IntCode do
  defmodule Program do
    defstruct instructions: Map.new(), pos: 0, inputs: [], outputs: [], halt: false, needs_input: false, relative_base: 0
  end

  @op_map %{ 99 => :halt, 1 => :add, 2 => :mult, 3 => :input, 4 => :output, 5 => :jumpif, 6 => :jumpunless, 7 => :lt, 8 => :eq, 9 => :relbase }

  def run_program(str, inputs \\ []) do
    map = parse_instructions(str)
    _run_program(%Program{instructions: map, pos: 0, inputs: inputs, outputs: []})
  end
  defp _run_program(%Program{halt: true} = prog), do: prog
  defp _run_program(%Program{needs_input: true} = prog), do: prog
  defp _run_program(prog) do
    { op, modes } = parse_op(prog.instructions[prog.pos])
    run_op(prog, @op_map[op], modes) |> _run_program
  end

  def resume_with_inputs(prog, inputs), do: _run_program( %{ prog | needs_input: false, inputs: inputs } )

  def parse_instructions(str) do
    str
    |> String.trim
    |> String.split(",")
    |> Enum.with_index(0)
    |> Enum.map(fn {k,v}->{v, String.to_integer(k)} end)
    |> Map.new
  end

  def get_instructions(prog) do
    indices = Map.keys(prog.instructions) |> Enum.sort
    (for i <- indices, do: prog.instructions[i]) |> Enum.join(",")
  end

  def parse_op(op) do
    { rem(op, 100),
      %{1 => rem(div(op,100),10),
        2 => rem(div(op,1000),10),
        3 => rem(div(op,10000),10),
        4 => rem(div(op,100000),10) } }
  end

  def vget(prog, offset, modes), do: _vget(prog, offset, modes[offset])
  def _vget(prog, offset, 0), do: Map.get(prog.instructions, Map.get(prog.instructions, prog.pos + offset, 0), 0)
  def _vget(prog, offset, 1), do: Map.get(prog.instructions, prog.pos + offset, 0)
  def _vget(prog, offset, 2), do: Map.get(prog.instructions, prog.relative_base + Map.get(prog.instructions, prog.pos + offset, 0), 0)

  def vset(prog, offset, val, modes), do: _vset(prog, offset, val, modes[offset])
  def _vset(prog, offset, val, 0) do
    set_pos = prog.instructions[prog.pos + offset]
    %{ prog | instructions: Map.put(prog.instructions, set_pos, val) }
  end
  def _vset(prog, offset, val, 2) do
    set_pos = prog.instructions[prog.pos + offset] + prog.relative_base
    %{ prog | instructions: Map.put(prog.instructions, set_pos, val) }
  end

  def jump_to(prog, pos), do: %{ prog | pos: pos }
  def advance(prog, offset), do: jump_to(prog, prog.pos + offset)
  def set_inputs(prog, inputs), do: %{ prog | inputs: inputs }

  def run_op(prog, :halt, _), do: %{ prog | halt: true }

  def run_op(prog, :add, modes) do
    vset(prog, 3, vget(prog, 1, modes) + vget(prog, 2, modes), modes) |> advance(4)
  end

  def run_op(prog, :mult, modes) do
    vset(prog, 3, vget(prog, 1, modes) * vget(prog, 2, modes), modes) |> advance(4)
  end

  def run_op(%Program{inputs: []} = prog, :input, _modes), do: %{ prog | needs_input: true }
  def run_op(prog, :input, modes) do
    [this_input | other_inputs] = prog.inputs
    vset(prog, 1, this_input, modes) |> set_inputs(other_inputs) |> advance(2)
  end

  def run_op(prog, :output, modes) do
    %{ prog | outputs: prog.outputs ++ [vget(prog, 1, modes)] } |> advance(2)
  end

  def run_op(prog, :jumpif, modes) do
    if vget(prog, 1, modes) != 0, do: jump_to(prog, vget(prog, 2, modes)), else: advance(prog, 3)
  end

  def run_op(prog, :jumpunless, modes) do
    if vget(prog, 1, modes) == 0, do: jump_to(prog, vget(prog, 2, modes)), else: advance(prog, 3)
  end

  def run_op(prog, :lt, modes) do
    val = if vget(prog, 1, modes) < vget(prog, 2, modes), do: 1, else: 0
    vset(prog, 3, val, modes) |> advance(4)
  end

  def run_op(prog, :eq, modes) do
    val = if vget(prog, 1, modes) == vget(prog, 2, modes), do: 1, else: 0
    vset(prog, 3, val, modes) |> advance(4)
  end

  def run_op(prog, :relbase, modes) do
    %{ prog | relative_base: prog.relative_base + vget(prog, 1, modes) } |> advance(2)
  end
end
