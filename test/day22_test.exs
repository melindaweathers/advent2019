defmodule Day22Test do
  use ExUnit.Case, async: true

  test "init_cards" do
    assert [0,1,2,3,4] == Day22.init_cards(5)
  end

  test "new_stack" do
    assert [4,3,2,1,0] == Day22.init_cards(5) |> Day22.new_stack
  end

  test "cut" do
    assert [3,4,5,6,7,8,9,0,1,2] == Day22.init_cards(10) |> Day22.cut(3)
    assert [6,7,8,9,0,1,2,3,4,5] == Day22.init_cards(10) |> Day22.cut(-4)
  end

  test "deal" do
    assert [0,7,4,1,8,5,2,9,6,3] == Day22.init_cards(10) |> Day22.deal(3)
  end

  test "shuffle" do
    assert [9,2,5,8,1,4,7,0,3,6] == Day22.shuffle_cards("inputs/day22-sample.txt", 10)
  end

  test "index_of" do
    assert 0 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 9)
    assert 1 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 2)
    assert 9 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 6)
  end
end
