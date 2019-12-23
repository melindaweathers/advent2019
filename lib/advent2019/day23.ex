defmodule NicComputer do
  require IntCode

  def run(program, sender, num) do
    receive do
      {x, y} ->
        #IO.inspect "#{num} received #{x},#{y}"
        process_inputs(program, [x,y], sender, num) |> run(sender, num)
      after 100 ->
        send sender, {:idle, num}
        process_inputs(program, [-1], sender, num) |> run(sender, num)
    end
  end

  def process_inputs(program, inputs, sender, num) do
    program = IntCode.resume_with_inputs(program, inputs)
    process_outputs(program.outputs, sender, num)
    %{ program | outputs: []}
  end

  def process_outputs([], _sender, _num), do: nil
  def process_outputs([address,x,y|tail], sender, num) do
    send sender, {:message, num, address, x, y}
    process_outputs(tail, sender, num)
  end
end

defmodule Nat do
  def start do
    receive do
      {x, y} ->
        run(x, y, nil)
    end
  end

  def run(lastx, lasty, lastsenty) do
    receive do
      {:send_last_xy, to} ->
        send to, {lastx, lasty}
        if lasty == lastsenty do
          IO.inspect "Nat sending #{lasty}"
        else
          run(lastx, lasty, lasty)
        end
      {x, y} ->
        run(x, y, lastsenty)
    end
  end
end

defmodule NicController do
  require IntCode

  def start_network(filename, num) do
    {:ok, operations} = File.read(filename)
    nat = spawn(Nat, :start, [])
    computers = Enum.map(0..num-1, fn num ->
      program = IntCode.run_program(operations, [num])
      { num, { :running, spawn(NicComputer, :run, [program, self(), num]) } }
    end) |> Map.new

    listen(nat, computers)
  end

  def listen(nat, computers) do
    receive do
      {:from_nat, x, y} ->
        send elem(computers[0], 1), {x, y}
        listen(nat, computers)
      {:idle, from} ->
        computers = set_idle(computers, from)
        if Enum.all?(Map.values(computers), fn c -> elem(c,0) == :idle end) do
          send nat, {:send_last_xy, elem(computers[0], 1)}
        end
        listen(nat, computers)
      {:message, from, 255, x, y} ->
        send nat, {x, y}
        listen(nat, set_running(computers, from))
      {:message, from, to, x, y}  ->
        send elem(computers[to],1), {x, y}
        listen(nat, set_running(computers, from))
    end
  end

  def set_running(computers, num), do: Map.put(computers, num, {:running, elem(computers[num],1)})
  def set_idle(computers, num), do: Map.put(computers, num, {:idle, elem(computers[num],1)})
end

#mix run -e 'Day23.run'
defmodule Day23 do
  def run do
    NicController.start_network("inputs/day23.txt", 50)
  end
end

