#mix run -e 'Day14.run'
defmodule Day14 do
  def load_file(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list
    |> Map.new
  end

  #{ output_name, { output_quantity, [{input_quantity, input_name}, ...]}}
  def parse_line(line) do
    [inputs, output] = String.split(line," => ")
    { o_quantity, o_name } = quantity_name(output)
    input_list = inputs |> String.split(", ") |> Enum.map(&quantity_name/1)
    { o_name, { o_quantity, input_list } }
  end

  def quantity_name(str) do
    [quantity, name] = String.split(str, " ")
    {String.to_integer(quantity), name}
  end

  def add_leftover(leftovers, name, amount) do
    Map.put(leftovers, name, Map.get(leftovers, name, 0) + amount)
  end

  def deduct_leftover(leftovers, name, amount) do
    available = Map.get(leftovers, name, 0)
    remaining_amount = max(0, amount - available)
    remaining_leftovers = Map.put(leftovers, name, max(0, available - amount))
    {remaining_amount, remaining_leftovers}
  end

  def process_element(_reactions, "ORE", quantity, leftovers), do: {quantity, leftovers}
  def process_element(reactions, element, quantity, leftovers) do
    {output_amount, inputs} = reactions[element]
    inputs_multiplier = ceil(quantity/output_amount)
    {ore_for_inputs, leftovers} = process_inputs(reactions, inputs, inputs_multiplier, 0, leftovers)
    leftover_for_element = inputs_multiplier*output_amount - quantity
    #IO.inspect(%{output_amount: output_amount, inputs: inputs, inputs_multiplier: inputs_multiplier, ore_for_inputs: ore_for_inputs, leftovers: leftovers, new_leftovers: add_leftover(leftovers, element, leftover_for_element) })
    {ore_for_inputs, add_leftover(leftovers, element, leftover_for_element)}
  end

  def process_inputs(_reactions, [], _, ore, leftovers), do: {ore, leftovers}
  def process_inputs(reactions, [{quantity, name}|tail], inputs_multiplier, ore, leftovers) do
    amount_required = quantity*inputs_multiplier
    {amount_required_after_leftover, remaining_leftovers} = deduct_leftover(leftovers, name, amount_required)
    {new_ore, remaining_leftovers} = process_element(reactions, name, amount_required_after_leftover, remaining_leftovers)
    process_inputs(reactions, tail, inputs_multiplier, ore + new_ore, remaining_leftovers)
  end

  def fuel_for_ore(reactions), do: _fuel_for_ore(reactions, 1000000000000, 0, %{}, 10000)
  defp _fuel_for_ore(_reactions, ore, fuel_count, _leftovers, 1) when ore <= 0, do: fuel_count - 1
  defp _fuel_for_ore(reactions, ore, fuel_count, leftovers, fuel_multiplier) do
    {quantity, new_leftovers} = process_element(reactions, "FUEL", fuel_multiplier, leftovers)
    if fuel_multiplier > 1 && ore <= quantity do
      _fuel_for_ore(reactions, ore, fuel_count, leftovers, div(fuel_multiplier, 10))
    else
      _fuel_for_ore(reactions, ore - quantity, fuel_count + fuel_multiplier, new_leftovers, fuel_multiplier)
    end
  end

  def run do
    IO.inspect("Should be 31")
    load_file('inputs/day14-sample1.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("Should be 165")
    load_file('inputs/day14-sample2.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("Should be 13312")
    load_file('inputs/day14-sample3.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("Should be 180697")
    load_file('inputs/day14-sample4.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("Should be 2210736")
    load_file('inputs/day14-sample5.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("First Star")
    load_file('inputs/day14.txt') |> process_element("FUEL", 1, %{}) |> elem(0) |> IO.inspect

    IO.inspect("Should be 82892753 fuel")
    load_file('inputs/day14-sample3.txt') |> fuel_for_ore |> IO.inspect

    IO.inspect("Should be 5586022 fuel")
    load_file('inputs/day14-sample4.txt') |> fuel_for_ore |> IO.inspect

    IO.inspect("Should be 460664 fuel")
    load_file('inputs/day14-sample5.txt') |> fuel_for_ore |> IO.inspect

    IO.inspect("Second Star")
    load_file('inputs/day14.txt') |> fuel_for_ore |> IO.inspect
  end
end
