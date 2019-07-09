defmodule PartialOrder do
  import KeyValue

  def partial_order_of_hand(hand) do
    if _check_keys_uniquness(hand) == 1 and _straight_flush(hand) == false do
      "Flush"
    else
      _get_partial_order(hand)
    end
  end

  defp _get_partial_order(hand) do
    occurance =
      hand
      |> convert_input_to_keyword
      |> count_occurence_of_each_value

    case occurance do
      [1, 1, 1, 1, 1] ->
        staight_or_straight_flush(hand)

      [1, 1, 1, 2] ->
        "Pair"

      [1, 1, 3] ->
        "Three of a Kind"

      [1, 4] ->
        "Four of a Kind"

      [2, 3] ->
        "Full House"

      [1, 2, 2] ->
        "Two Pair"

      _ ->
        "High Card"
    end
  end

  defp staight_or_straight_flush(hand) do
    if _straight_flush(hand) do
      "Straight Flush"
    else
      if _check_order_value(hand) do
        "Straight"
      else
        "High Card"
      end
    end
  end

  defp _straight_flush(hand) do
    _check_order_value(hand) and _check_keys_uniquness(hand) == 1
  end

  defp _check_order_value(hand) do
    values =
      hand
      |> convert_input_to_keyword
      |> get_values_in_hand

    values == Enum.min(values)..Enum.max(values) |> Enum.to_list()
  end

  defp _check_keys_uniquness(hand) do
    hand
    |> convert_input_to_keyword
    |> Keyword.keys()
    |> Enum.uniq()
    |> length
  end

  def get_highest_value_in_hand(hand) do
    hand
    |> convert_input_to_keyword
    |> get_values_in_hand
    |> Enum.max()
  end

  def get_values_in_hand(hand) do
    values = Keyword.values(hand)

    values
    |> Enum.map(fn val ->
      if Regex.match?(~r/[\d]/, val) do
        String.to_integer(val)
      else
        case val do
          "T" -> 10
          "J" -> 11
          "Q" -> 12
          "K" -> 13
          "A" -> 14
        end
      end
    end)
  end
end
