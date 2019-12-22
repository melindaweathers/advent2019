defmodule Day22Test do
  use ExUnit.Case, async: true

  def to_list(map), do: Enum.map(0..map_size(map)-1, fn i -> map[i] end)

  test "init_cards" do
    assert [0,1,2,3,4] == Day22.init_cards(5)
    assert 1 == Day22.t_init_cards(5, 1).pos
    assert 4 == Day22.t_init_cards(5, 4).pos
  end

  test "new_stack" do
    assert [4,3,2,1,0] == Day22.init_cards(5) |> Day22.new_stack
    assert 3 == Day22.t_init_cards(5, 1) |> Day22.t_new_stack |> Map.get(:pos)
  end

  test "cut" do
    assert [3,4,5,6,7,8,9,0,1,2] == Day22.init_cards(10) |> Day22.cut(3)
    assert [6,7,8,9,0,1,2,3,4,5] == Day22.init_cards(10) |> Day22.cut(-4)
    assert 8 == Day22.t_init_cards(10, 1) |> Day22.t_cut(3) |> Map.get(:pos)
    assert 5 == Day22.t_init_cards(10, 1) |> Day22.t_cut(-4) |> Map.get(:pos)
  end

  test "deal" do
    assert [0,7,4,1,8,5,2,9,6,3] == Day22.init_cards(10) |> Day22.deal(3)
    assert 3 == Day22.t_init_cards(10, 1) |> Day22.t_deal(3) |> Map.get(:pos)
  end

  test "shuffle" do
    assert [9,2,5,8,1,4,7,0,3,6] == Day22.shuffle_cards("inputs/day22-sample.txt", 10)
  end

  test "index_of" do
    assert 0 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 9)
    assert 1 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 2)
    assert 9 == Day22.index_of([9,2,5,8,1,4,7,0,3,6], 6)
  end

  test "shuffle_n_times" do
    assert 0 == Day22.t_shuffle_cards("inputs/day22-sample2.txt", 10, 0) |> Map.get(:pos)
    assert 0 == Day22.t_shuffle_n_times("inputs/day22-sample2.txt", 10, 0, 10) |> Map.get(:pos)
  end
end
