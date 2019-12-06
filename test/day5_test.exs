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

  test "equals and less than" do
    # Test input is equal to 8
    assert Day5.run_program("3,9,8,9,10,9,4,9,99,-1,8", [8]).outputs == [1]
    assert Day5.run_program("3,9,8,9,10,9,4,9,99,-1,8", [2]).outputs == [0]

    # Test input is less than 8
    assert Day5.run_program("3,9,7,9,10,9,4,9,99,-1,8", [7]).outputs == [1]
    assert Day5.run_program("3,9,7,9,10,9,4,9,99,-1,8", [8]).outputs == [0]
    assert Day5.run_program("3,9,7,9,10,9,4,9,99,-1,8", [9]).outputs == [0]

    # Test input is equal to 8
    assert Day5.run_program("3,3,1108,-1,8,3,4,3,99", [8]).outputs == [1]
    assert Day5.run_program("3,3,1108,-1,8,3,4,3,99", [2]).outputs == [0]

    # Test input is less than 8
    assert Day5.run_program("3,3,1107,-1,8,3,4,3,99", [2]).outputs == [1]
    assert Day5.run_program("3,3,1107,-1,8,3,4,3,99", [8]).outputs == [0]
    assert Day5.run_program("3,3,1107,-1,8,3,4,3,99", [9]).outputs == [0]
  end

  test "jumps" do
    assert Day5.run_program("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [0]).outputs == [0]
    assert Day5.run_program("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", [2]).outputs == [1]
    assert Day5.run_program("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", [0]).outputs == [0]
    assert Day5.run_program("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", [2]).outputs == [1]
  end

  test "larger example" do
    prog1 = Day5.run_program("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [7])
    assert prog1.outputs == [999]
    prog2 = Day5.run_program("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [8])
    assert prog2.outputs == [1000]
    prog3 = Day5.run_program("3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99", [9])
    assert prog3.outputs == [1001]
  end
end
