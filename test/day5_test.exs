defmodule Day5Test do
  use ExUnit.Case, async: true

  test "halt immediately" do
    assert Day5.run_program("99") |> Day5.get_instructions == "99"
  end

  test "simple tests" do
    assert Day5.run_program("1,0,0,0,99") |> Day5.get_instructions == "2,0,0,0,99"
    assert Day5.run_program("1,0,0,0,99") |> Day5.get_instructions == "2,0,0,0,99"
    assert Day5.run_program("1,9,10,3,2,3,11,0,99,30,40,50") |> Day5.get_instructions == "3500,9,10,70,2,3,11,0,99,30,40,50"
    assert Day5.run_program("2,3,0,3,99") |> Day5.get_instructions == "2,3,0,6,99"
    assert Day5.run_program("2,4,4,5,99,0") |> Day5.get_instructions == "2,4,4,5,99,9801"
    assert Day5.run_program("1,1,1,4,99,5,6,0,99") |> Day5.get_instructions == "30,1,1,4,2,5,6,0,99"
  end

  test "inputs and outputs" do
    program = Day5.run_program("3,0,4,0,99", [123])
    assert program.outputs == [123]
    assert Day5.get_instructions(program) == "123,0,4,0,99"
  end

  test "param modes" do
    assert Day5.run_program("1002,4,3,4,33") |> Day5.get_instructions == "1002,4,3,4,99"
  end

  test "negative values" do
    assert Day5.run_program("1101,100,-1,4,0") |> Day5.get_instructions == "1101,100,-1,4,99"
  end
end
