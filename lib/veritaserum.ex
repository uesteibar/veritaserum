defmodule Veritaserum do
  @moduledoc """
  Sentiment analisis based on AFINN-165, emojis and some enhancements.

  Also supports:
  - emojis (❤️, 😱...)
  - boosters (*very*, *really*...)
  - negators (*don't*, *not*...).
  """

  alias Veritaserum.Evaluator

  @spec analyze(List.t()) :: Integer.t()
  def analyze(input) when is_list(input) do
    input
    |> Stream.map(&analyze/1)
    |> Enum.to_list()
  end

  @doc """
  Returns a sentiment value for the given text

      iex> Veritaserum.analyze(["I ❤️ Veritaserum", "Veritaserum is really awesome"])
      [3, 5]

      iex> Veritaserum.analyze("I love Veritaserum")
      3
  """
  @spec analyze(String.t()) :: Integer.t()
  def analyze(input, return: :score_and_marks) do
    list_with_marks = get_list_with_marks(input)
    score = get_score(list_with_marks)

    {score, list_with_marks}
  end

  def analyze(input) do
    {score, _} = analyze(input, return: :score_and_marks)

    score
  end

  defp get_score(words) do
    words
    |> analyze_list
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp get_list_with_marks(input) do
    input
    |> clean
    |> String.split()
    |> split_on_emoticons
    |> mark_list
    |> Enum.reverse()
  end

  defp mark_word(word) do
    with {_, nil, _} <- {:negator, Evaluator.evaluate_negator(word), word},
         {_, nil, _} <- {:booster, Evaluator.evaluate_booster(word), word},
         {_, nil, _} <- {:emoticon, Evaluator.evaluate_emoticon(word), word},
         {_, nil, _} <- {:word, Evaluator.evaluate_word(word), word},
         do: {:neutral, 0, word}
  end

  defp mark_list([head | tail]) do
    mark_list(tail, [mark_word(head)])
  end

  defp mark_list([head | tail], result) do
    mark_list(tail, [mark_word(head) | result])
  end

  defp mark_list([], result), do: result

  defp analyze_mark({type, score, _}) do
    case type do
      :word -> score
      :emoticon -> score
      _ -> 0
    end
  end

  defp analyze_mark(mark, previous) do
    case previous do
      {:negator, _, _} ->
        -analyze_mark(mark)

      {:booster, booster_value, _} ->
        analyze_mark(mark) |> apply_booster(booster_value)

      _ ->
        analyze_mark(mark)
    end
  end

  defp analyze_list([head | tail]) do
    analyze_list(tail, head, [analyze_mark(head)])
  end

  defp analyze_list([head | tail], previous, result) do
    analyze_list(tail, head, [analyze_mark(head, previous) | result])
  end

  defp analyze_list([], _, result), do: result

  defp apply_booster(word_value, booster) when word_value > 0, do: word_value + booster
  defp apply_booster(word_value, booster) when word_value < 0, do: word_value - booster
  defp apply_booster(word_value, _booster), do: word_value

  defp clean(text) do
    text
    |> String.replace(~r/\n/, " ")
    |> String.downcase()
    |> String.replace(~r/[.,\/#!$%\^&\*;:{}=_`\"~()]/, " ")
    |> String.replace(~r/ {2,}/, " ")
  end

  defp split_on_emoticons(text_list) when is_list(text_list) do
    split_on_emoticons(Evaluator.emoticon_list(), text_list)
    |> Enum.filter(&(&1 != ""))
  end

  defp split_on_emoticons([head | tail], text_list) do
    new_text_list =
      text_list
      |> Enum.map(fn string ->
        string
        |> String.split(~r/#{head}/, include_captures: true)
      end)
      |> List.flatten()

    split_on_emoticons(tail, new_text_list)
  end

  defp split_on_emoticons([], text_list) do
    text_list
  end
end
