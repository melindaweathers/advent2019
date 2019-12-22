#mix run -e 'Day22.run'
defmodule Day22 do
  defmodule TrackedCard do
    defstruct num: 0, pos: 0, size: 10
  end

  def init_cards(num), do: Enum.map(0..num-1, fn x -> x end)
  def t_init_cards(size, tracked), do: %TrackedCard{num: tracked, pos: tracked, size: size}

  def new_stack(cards), do: Enum.reverse(cards)
  def t_new_stack(tracked), do: %{ tracked | pos: tracked.size - tracked.pos - 1 }

  def cut(cards, amount) when amount < 0, do: cut(cards, length(cards) + amount)
  def cut(cards, amount), do: _cut(cards, amount, [])
  defp _cut(cards, 0, new_stack), do: cards ++ Enum.reverse(new_stack)
  defp _cut([head|cards], amount, new_stack) do
    _cut(cards, amount - 1, [head|new_stack])
  end
  def t_cut(tracked, amount) when amount < 0, do: t_cut(tracked, tracked.size + amount)
  def t_cut(tracked, amount) do
    if amount <= tracked.pos do
      %{ tracked | pos: tracked.pos - amount }
    else
      %{ tracked | pos: tracked.size - amount + tracked.pos }
    end
  end

  def deal(cards, increment), do: _deal(cards, increment, 0, length(cards), %{})
  defp _deal([], _, _, size, dealt), do: Enum.map(0..size-1, fn i -> dealt[i] end)
  defp _deal([head|tail], increment, idx, size, dealt) do
    _deal(tail, increment, rem(idx + increment, size), size, Map.put(dealt, idx, head))
  end
  def t_deal(tracked, increment), do: %{ tracked | pos: rem(tracked.pos * increment, tracked.size) }

  def read_instructions(filename) do
    File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&(String.split(&1, " ")))
      |> Enum.to_list
  end

  def run_instruction(["cut", size], cards), do: cut(cards, String.to_integer(size))
  def run_instruction(["deal", "into"|_], cards), do: new_stack(cards)
  def run_instruction(["deal", "with", "increment", inc], cards), do: deal(cards, String.to_integer(inc))

  def t_run_instruction(["cut", size], tracked), do: t_cut(tracked, String.to_integer(size))
  def t_run_instruction(["deal", "into"|_], tracked), do: t_new_stack(tracked)
  def t_run_instruction(["deal", "with", "increment", inc], tracked), do: t_deal(tracked, String.to_integer(inc))

  def shuffle_cards(filename, num), do: _shuffle_cards(read_instructions(filename), init_cards(num))
  defp _shuffle_cards([], cards), do: cards
  defp _shuffle_cards([head|instructions], cards) do
    _shuffle_cards(instructions, run_instruction(head, cards))
  end

  def t_shuffle_cards(filename, num, tracked_num), do: _t_shuffle_cards(read_instructions(filename), t_init_cards(num, tracked_num))
  defp _t_shuffle_cards([], tracked), do: tracked
  defp _t_shuffle_cards([head|instructions], tracked) do
    _t_shuffle_cards(instructions, t_run_instruction(head, tracked))
  end

  def t_shuffle_n_times(filename, num, tracked_num, n) do
    _t_shuffle_n_times(read_instructions(filename), t_init_cards(num, tracked_num), n, [], true)
  end
  defp _t_shuffle_n_times(_instructions, tracked, 0, _, _), do: tracked
  defp _t_shuffle_n_times(instructions, tracked, n, results, track_cycles) do
    new_tracked = _t_shuffle_cards(instructions, tracked)
    results_pos = Enum.find_index(results, fn x -> x == new_tracked.pos end)
    if track_cycles && results_pos do
      cycle_index = length(results) - results_pos - 1
      cycle_size = length(results) - cycle_index
      IO.puts "Found cycle after #{cycle_size} times"
      remaining_n = rem(n, cycle_size)
      IO.puts "remaining: #{remaining_n}"
      _t_shuffle_n_times(instructions, new_tracked, remaining_n, [], false)
    else
      _t_shuffle_n_times(instructions, new_tracked, n - 1, [new_tracked.pos|results], true)
    end
  end

  def index_of(cards, num), do: Enum.find_index(cards, fn x -> x == num end)

  def run do
    shuffle_cards("inputs/day22.txt", 10007) |> index_of(2019) |> IO.inspect

    # Track only the card we care about
    t_shuffle_cards("inputs/day22.txt", 10007, 2019) |> IO.inspect

    t_shuffle_n_times("inputs/day22.txt", 119315717514047, 2020, 101741582076661) |> IO.inspect
  end
end
