defmodule Day2Test do
  use ExUnit.Case, async: true

  test "string to map" do
    assert Day2.str_to_map("1,0,0,0,99") |> Day2.map_to_str == "1,0,0,0,99"
  end

  test "simple run_program" do
    assert Day2.run_program("99") |> Day2.map_to_str == "99"
  end

  test "run_program" do
    assert Day2.run_program("1,0,0,0,99") |> Day2.map_to_str == "2,0,0,0,99"
    assert Day2.run_program("1,9,10,3,2,3,11,0,99,30,40,50") |> Day2.map_to_str == "3500,9,10,70,2,3,11,0,99,30,40,50"
    assert Day2.run_program("2,3,0,3,99") |> Day2.map_to_str == "2,3,0,6,99"
    assert Day2.run_program("2,4,4,5,99,0") |> Day2.map_to_str == "2,4,4,5,99,9801"
    assert Day2.run_program("1,1,1,4,99,5,6,0,99") |> Day2.map_to_str == "30,1,1,4,2,5,6,0,99"
  end
end
