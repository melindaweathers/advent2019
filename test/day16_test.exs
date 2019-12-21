defmodule Day16Test do
  use ExUnit.Case, async: true

  test "next phase" do
    assert "48226158" == "12345678" |> Day16.next_phase |> Enum.map(&(elem(&1,0))) |> Enum.join("")
    assert "34040438" == "48226158" |> Day16.next_phase |> Enum.map(&(elem(&1,0))) |> Enum.join("")
    assert "03415518" == "34040438" |> Day16.next_phase |> Enum.map(&(elem(&1,0))) |> Enum.join("")
    assert "01029498" == "03415518" |> Day16.next_phase |> Enum.map(&(elem(&1,0))) |> Enum.join("")
  end

  test "first eight" do
    assert "24176176" == "80871224585914546619083218645595" |> Day16.first_eight_after_a_hundred
    assert "73745418" == "19617804207202209144916044189917" |> Day16.first_eight_after_a_hundred
    assert "52432133" == "69317163492948606335995924319873" |> Day16.first_eight_after_a_hundred
  end
end
