defmodule PokerTest do
  use ExUnit.Case
  doctest Poker

  test "determine the partial order of a card" do
    assert PartialOrder.partial_order_of_hand("2H 3H 4H 5H 6H") == "Straight Flush"
    assert PartialOrder.partial_order_of_hand("7H 8D 9S TC JD") == "Straight"
    assert PartialOrder.partial_order_of_hand("2H 3D 5S 9C KD") == "High Card"
  end

  test "determine the highest value in a hand" do
    assert PartialOrder.get_highest_value_in_hand("2H 3H 4H 5H 6H") == 6
    assert PartialOrder.get_highest_value_in_hand("7H 8D 9S TC JD") == 11
    assert PartialOrder.get_highest_value_in_hand("2H 3D 5S 9C KD") == 13
  end

  test "compare any other card and Straight" do
    assert Poker.main("2H 3D 5S 9C KD", "2S 3D 4S 5C 6H") == "Black wins - High Card: 13"
  end

  test "compare any other card and Straight Flush" do
    assert Poker.main("2H 3D 5S 9C KD", "2H 3H 4H 5H 6H") == "Black wins - High Card: 13"
  end

  test "compare straight and straight flush" do
    assert Poker.main("1H 2D 3S 4C 5D", "2H 3H 4H 5H 6H") == "White Wins Straight Flush- 6"
    assert Poker.main("7H 8D 9S TC JD", "2H 3H 4H 5H 6H") == "Black Wins Straight- 11"
  end

  test "compare three of a kind and flush" do
    assert Poker.main("2H 4S 4C 3D 4H", "2S 8S AS QS 3S") == "White wins - flush: 14"
  end

  test "compare four of a kind and flush" do
    assert Poker.main("2H 4S 4C 3D 4H", "8S 8S 8S 8S 3S") == "White wins - flush: 8"
  end

  test "compare two high card hands" do
    assert Poker.main("2H 3D 5S 9C KD", "2C 3H 4S 8C KH") == "Black wins - high card: 9"
  end

  test "two cards with a tie" do
    assert Poker.main("3H 4D 5S 6C 7D", "3D 4H 5C 6S 7H") == "Tie"
  end

  test "convert letter values to integer values" do
    keyword = "TH JS QC KD AH" |> KeyValue.convert_input_to_keyword()
    assert keyword |> PartialOrder.get_values_in_hand() == [10, 11, 12, 13, 14]
  end
end
