defmodule KeyValue do
  def convert_input_to_keyword(hand) do
    hand
    |> String.split(" ")
    |> Enum.map(fn card -> String.split(card, "", trim: true) end)
    |> Enum.map(fn card ->
      suit = Enum.at(card, -1)
      suit = String.to_atom(suit)
      value = Enum.at(card, 0)
      {suit, value}
    end)
  end

  @spec count_occurence_of_each_value(keyword) :: [any]
  def count_occurence_of_each_value(hand) do
    values = Keyword.values(hand)

    values
    |> Enum.uniq()
    |> Enum.map(fn uniq_value ->
      Enum.count(values, fn specific_value -> specific_value == uniq_value end)
    end)
    |> Enum.sort()
  end
end
