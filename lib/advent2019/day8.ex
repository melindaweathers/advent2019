#mix run -e 'Day8.run'
defmodule Day8 do
  def split_to_layers(input, width, height) do
    input
    |> String.trim
    |> String.codepoints
    |> Enum.chunk_every(width * height)
  end

  def count_digits(layer, digit) do
    (for char <- layer, char == digit, do: char) |> Enum.count
  end

  def layer_with_fewest_zeroes(layers) do
    {_, _, _, layer} = Enum.reduce(layers, { 0, 10000000, 0, [] }, fn layer, { min_idx, min_zeroes, i, min_layer } ->
      count = count_digits(layer, "0")
      if count < min_zeroes, do: { i, count, i+1, layer }, else: { min_idx, min_zeroes, i+1, min_layer }
    end)
    layer
  end

  def ones_times_twos(layer), do: count_digits(layer, "1") * count_digits(layer, "2")

  def reduce_layers(layers) do
    Enum.reduce(layers, fn layer, acc ->
      for {top, bottom} <- Enum.zip(acc, layer), do: (if top == "2", do: bottom, else: top)
    end)
  end

  def print_layers(layers, width) do
    layers
    |> reduce_layers
    |> Enum.chunk_every(width)
    |> Enum.map(&(IO.puts(Enum.join(&1))))
  end

  def run do
    {:ok, input} = File.read('inputs/day8.txt')
    layers = split_to_layers(input, 25, 6)
    layers |> layer_with_fewest_zeroes |> ones_times_twos |> IO.inspect
    print_layers(layers, 25)
  end
end
