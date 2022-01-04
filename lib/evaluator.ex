defmodule Veritaserum.Evaluator do
  @moduledoc """
  Evaluates words, boosters, negators and emoticons.
  """

  ["word", "emoticon", "negator", "booster"]
  |> Enum.each(fn facet ->
    facet_mapping =
      "#{__DIR__}/../config/facets/#{facet}.json"
      |> File.read!()
      |> Jason.decode!()

    @doc """
    Returns a list of words/emojis which affect **#{facet}** sentiment.

        Veritaserum.Evaluator.#{facet}_list()
    """
    def unquote(:"#{facet}_list")(),
      do: unquote(Map.keys(facet_mapping))

    @doc """
    Evaluates if a word/emoji is a **#{facet}** and returns value.
    Otherwise returns `nil`.

        Veritaserum.Evaluator.evaluate_#{facet}("very")
        Veritaserum.Evaluator.evaluate_#{facet}("can't")
        Veritaserum.Evaluator.evaluate_#{facet}("afraid")
    """
    def unquote(:"evaluate_#{facet}")(word_or_emoji)

    Enum.each(facet_mapping, fn {word, value} ->
      def unquote(:"evaluate_#{facet}")(unquote(word)), do: unquote(value)
    end)

    def unquote(:"evaluate_#{facet}")(_), do: nil
  end)
end
