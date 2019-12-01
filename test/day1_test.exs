defmodule Day1Test do
  use ExUnit.Case, async: true

  test "calc_recursive_fuel" do
    assert Day1.calc_recursive_fuel(14) == 2
    assert Day1.calc_recursive_fuel(1969) == 966
    assert Day1.calc_recursive_fuel(100756) == 50346
  end

  test "calc_file" do
    assert Day1.calc_file('inputs/day1-sample.txt', &Day1.calc_fuel/1) == 34241
  end
end
