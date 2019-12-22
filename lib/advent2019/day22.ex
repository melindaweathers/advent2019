#mix run -e 'Day22.run'
defmodule Day22 do
  def init_cards(num), do: Enum.map(0..num-1, fn x -> x end)
  def new_stack(cards), do: Enum.reverse(cards)

  def cut(cards, amount) when amount < 0, do: cut(cards, length(cards) + amount)
  def cut(cards, amount), do: _cut(cards, amount, [])
  defp _cut(cards, 0, new_stack), do: cards ++ Enum.reverse(new_stack)
  defp _cut([head|cards], amount, new_stack) do
    _cut(cards, amount - 1, [head|new_stack])
  end

  def deal(cards, increment), do: _deal(cards, increment, 0, length(cards), %{})
  defp _deal([], _, _, size, dealt), do: Enum.map(0..size-1, fn i -> dealt[i] end)
  defp _deal([head|tail], increment, idx, size, dealt) do
    _deal(tail, increment, rem(idx + increment, size), size, Map.put(dealt, idx, head))
  end

  def read_instructions(filename) do
    File.stream!(filename)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&(String.split(&1, " ")))
      |> Enum.to_list
  end

  def run_instruction(["cut", size], cards), do: cut(cards, String.to_integer(size))
  def run_instruction(["deal", "into"|_], cards), do: new_stack(cards)
  def run_instruction(["deal", "with", "increment", inc], cards), do: deal(cards, String.to_integer(inc))

  def shuffle_cards(filename, num), do: _shuffle_cards(read_instructions(filename), init_cards(num))
  defp _shuffle_cards([], cards), do: cards
  defp _shuffle_cards([head|instructions], cards) do
    _shuffle_cards(instructions, run_instruction(head, cards))
  end

  def index_of(cards, num), do: Enum.find_index(cards, fn x -> x == num end)

  def run do
    shuffle_cards("inputs/day22.txt", 10007) |> index_of(2019) |> IO.inspect
  end
end
