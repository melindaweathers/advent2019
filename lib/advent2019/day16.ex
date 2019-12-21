#mix run -e 'Day16.run'
defmodule Day16 do

  def next_phase(signal) when is_list(signal), do: next_phase(signal, 0, length(signal), [])
  def next_phase(str), do: str |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) |> Enum.with_index |> next_phase
  def next_phase(_signal, i, i, transformed), do: transformed |> Enum.reverse
  def next_phase(signal, i, len, transformed) do
    new_head = ones_value(calc_new_value(signal, i))
    [_|rest_of_signal] = signal # Chuck the first part of the signal since it will always be zero.
    next_phase(rest_of_signal, i+1, len, [{new_head,i}|transformed])
  end

  def calc_new_value(signal, i), do: _calc_new_value(signal, i, 0)
  defp _calc_new_value([], _i, sum), do: sum
  defp _calc_new_value([{val, pos}|tail], i, sum) do
    n = div(pos-i,i+1)
    mult = rem(n+1,2)*-1*(2*rem(div(n,2),2) - 1)
    _calc_new_value(tail, i, sum + val*mult)
  end

  def ones_value(val), do: rem(abs(val),10)

  def first_eight_after_a_hundred(str) do
    Enum.reduce(1..100, str, fn _, signal -> next_phase(signal) end)
    |> Enum.slice(0, 8)
    |> Enum.map(&(elem(&1,0)))
    |> Enum.join
  end

  def run do
    IO.puts "First Star"
    signal = "59766977873078199970107568349014384917072096886862753001181795467415574411535593439580118271423936468093569795214812464528265609129756216554981001419093454383882560114421882354033176205096303121974045739484366182044891267778931831792562035297585485658843180220796069147506364472390622739583789825303426921751073753670825259141712329027078263584903642919122991531729298497467435911779410970734568708255590755424253797639255236759229935298472380039602200033415155467240682533288468148414065641667678718893872482168857631352275667414965503393341925955626006552556064728352731985387163635634298416016700583512112158756656289482437803808487304460165855189"
    signal |> first_eight_after_a_hundred |> IO.inspect
  end
end
