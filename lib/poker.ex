defmodule Poker do
  import PartialOrder
  import KeyValue

  def main(black, white) do
    h =
      black
      |> partial_order_of_hand()

    t =
      white
      |> partial_order_of_hand()

    _check_partial_order([h | t], black, white)
  end

  def _check_partial_order([h | t], black, white) do
    case [h | t] do
      [h | t]
      when (h == "Straight" or h == "Straight Flush") and
             (t == "Straight Flush" or t == "Straight") ->
        double_straight(black, h, white, t)

      [h | t] when h == "Pair" and (t == "Straight" or t == "Straight Flush") ->
        straights_and_pair(black, h, white, t)

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "Pair" ->
        straights_and_pair(black, h, white, t)

      [h | t] when h == "High Card" and (t == "Straight" or t == "Straight Flush") ->
        straight_and_high_card(black, h, white, t)

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "High Card" ->
        straights_and_pair(black, h, white, t)

      [h | t]
      when h == (t == "Three of a Kind" or t == "Four of a Kind") and
             (t == "Straight" or t == "Straight Flush") ->
        three_of_a_kind_straights(black, h, white, t)

      [h | t]
      when (h == "Straight" or h == "Straight Flush") and
             (t == "Three of a Kind" or t == "Four of a Kind") ->
        three_of_a_kind_straights(black, h, white, t)

      [h | t] when h == "Full House" and (t == "Straight" or t == "Straight Flush") ->
        straights_full_house(black, h, white, t)

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "Full House" ->
        straights_full_house(black, h, white, t)
    end
  end

  defp _pair_value(hand) do
    hand
    |> convert_input_to_keyword
    |> get_values_in_hand
  end

  def double_straight(black, h, white, t) do
    white = get_highest_value_in_hand(white)
    black = get_highest_value_in_hand(black)

    if black > white do
      "Black Wins #{h}- #{black}"
    else
      if white > black do
        "White Wins #{t}- #{white}"
      else
        "Tie"
      end
    end
  end

  def straights_and_pair(black, h, white, t) do
    case [h | t] do
      [h | t] when h == "Pair" and (t == "Straight" or t == "Straight Flush") ->
        black_values = _pair_value(black)

        uniq_values = Enum.uniq(black_values)

        [black] = black_values -- uniq_values

        white = get_highest_value_in_hand(white)

        case compare_pair(black, white) do
          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end

          "equal" ->
            new_max = List.delete(black_values, black) |> Enum.max()

            if new_max > white do
              "Black Wins #{h}- #{new_max}"
            else
              "White Wins #{t}- #{white}"
            end
        end

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "Pair" ->
        white_values = _pair_value(white)

        uniq_values = Enum.uniq(white_values)

        [white] = white_values -- uniq_values

        black = get_highest_value_in_hand(black)

        case compare_pair(black, white) do
          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end

          "equal" ->
            new_max = List.delete(white_values, white) |> Enum.max()

            if new_max > white do
              "Black Wins #{h}- #{new_max}"
            else
              "White Wins #{t}- #{white}"
            end
        end
    end
  end

  def compare_pair(black, white) do
    if black == white do
      "equal"
    else
      "not equal"
    end
  end

  def straight_and_high_card(black, h, white, t) do
    black_values = _pair_value(black)
    white_values = _pair_value(white)
    white = get_highest_value_in_hand(white)
    black = get_highest_value_in_hand(black)

    case [h | t] do
      [h | t] when h == "High Card" and (t == "Straight" or t == "Straight Flush") ->
        case compare_pair(black, white) do
          "equal" ->
            new_max = List.delete(black_values, black) |> Enum.max()

            if new_max > white do
              "Black wins - #{h}: #{new_max}"
            else
              "White wins - #{t}: #{white}"
            end

          "not equal" ->
            if black > white do
              "Black wins - #{h}: #{black}"
            else
              "White wins - #{t}: #{white}"
            end
        end

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "High Card" ->
        case compare_pair(black, white) do
          "equal" ->
            new_max = List.delete(white_values, white) |> Enum.max()

            if new_max > white do
              "Black wins - #{h}: #{new_max}"
            else
              "White wins - #{t}: #{white}"
            end

          "not equal" ->
            if black > white do
              "Black wins - #{h}: #{black}"
            else
              "White wins - #{t}: #{white}"
            end
        end
    end
  end

  def three_of_a_kind_straights(black, h, white, t) do
    case [h | t] do
      [h | t]
      when h == (t == "Three of a Kind" or t == "Four of a Kind") and
             (t == "Straight" or t == "Straight Flush") ->
        black_values = _pair_value(black)
        uniq_values = Enum.uniq(black_values)
        black = (black_values -- uniq_values) |> Enum.at(0)
        white = get_highest_value_in_hand(white)

        case compare_pair(black, white) do
          "equal" ->
            "Tie"

          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end
        end

      [h | t]
      when (h == "Straight" or h == "Straight Flush") and
             (t == "Three of a Kind" or t == "Four of a Kind") ->
        white_values = _pair_value(white)
        uniq_values = Enum.uniq(white_values)
        white = (white_values -- uniq_values) |> Enum.at(0)
        black = get_highest_value_in_hand(black)

        case compare_pair(black, white) do
          "equal" ->
            "Tie"

          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end
        end
    end
  end

  def straights_full_house(black, h, white, t) do
    case [h | t] do
      [h | t] when h == "Full House" and (t == "Straight" or t == "Straight Flush") ->
        white = get_highest_value_in_hand(white)
        black_values = _pair_value(black)
        uniq_values = black_values -- Enum.uniq(black_values)
        black_values = uniq_values |> Enum.uniq()
        black = (uniq_values -- black_values) |> Enum.at(0)

        case compare_pair(black, white) do
          "equal" ->
            "Tie"

          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end
        end

      [h | t] when (h == "Straight" or h == "Straight Flush") and t == "Full House" ->
        black = get_highest_value_in_hand(black)
        white_values = _pair_value(white)
        uniq_values = white_values -- Enum.uniq(white_values)
        white_values = uniq_values |> Enum.uniq()
        white = (uniq_values -- white_values) |> Enum.at(0)

        case compare_pair(black, white) do
          "equal" ->
            "Tie"

          "not equal" ->
            if black > white do
              "Black Wins #{h}- #{black}"
            else
              "White Wins #{t}- #{white}"
            end
        end
    end
  end
end
