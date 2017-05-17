defmodule Veritaserum do
  @moduledoc """
  Sentiment analisis based on AFINN-165, emojis and some enhancements.

  Also supports:
  - emojis (❤️, 😱...)
  - boosters (*very*, *really*...)
  - negators (*don't*, *not*...).
  """

  alias Veritaserum.Evaluator

  @spec analyze(List.t) :: Integer.t
  def analyze(input) when is_list(input) do
    input
    |> Stream.map(&analyze/1)
    |> Enum.to_list
  end

  @doc """
  Returns a sentiment value for the given text

      iex> Veritaserum.analyze(["I ❤️ Veritaserum", "Veritaserum is really awesome"])
      [3, 5]

      iex> Veritaserum.analyze("I love Veritaserum")
      3
  """
  @spec analyze(String.t) :: Integer.t
  def analyze(input) do
    input
    |> clean
    |> String.split
    |> analyze_list()
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp analyze_list([head | tail]) do
    analyze_list(tail, head, [analyze_word(head)])
  end
  defp analyze_list([head | tail], previous, result) do
    analyze_list(tail, head, [analyze_word(head, previous) | result])
  end
  defp analyze_list([], _, result), do: result

  defp analyze_word(word) do
    Evaluator.evaluate_word(word)
  end

  defp analyze_word(word, previous) do
    case Evaluator.evaluate_negator(previous) do
      1 -> - analyze_word(word)
      0 -> analyze_word_for_boosters(word, previous)
    end
  end

  defp analyze_word_for_boosters(word, previous) do
    case Evaluator.evaluate_booster(previous) do
      0 -> analyze_word(word)
      val -> word |> analyze_word |> apply_booster(val)
    end
  end

  defp apply_booster(word_value, booster) when word_value > 0, do: word_value + booster
  defp apply_booster(word_value, booster) when word_value < 0, do: word_value - booster
  defp apply_booster(word_value, _booster), do: word_value

  defp clean(text) do
    text
    |> String.strip
    |> String.replace(~r/\n/, "")
    |> String.downcase
    |> String.replace(~r/[.,\/#!$%\^&\*;:{}=_`\"~()]/, "")
    |> String.replace(~r/ {2,}/, " ")
  end
end
