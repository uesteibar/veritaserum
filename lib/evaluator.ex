defmodule Veritaserum.Evaluator do
  ["word", "negator", "booster"]
  |> Enum.each(fn facet ->
    File.read!("#{__DIR__}/../config/facets/#{facet}.json")
    |> Poison.Parser.parse!
    |> Enum.each(fn {word, value} ->

      @doc """
      Evaluates if a word/emoji is a **#{facet}** and returns value.

          iex> Veritaserum.Evaluator.evaluate_#{facet}("#{word}")
          #{value}
      """
      def unquote(:"evaluate_#{facet}")(unquote(word)), do: unquote(value)
    end)

    def unquote(:"evaluate_#{facet}")(_), do: 0
  end)
end
