defmodule Veritaserum.Evaluator do
  @moduledoc """
  Evaluats words, boosters, negators and emoticons.
  """

  ["word", "emoticon", "negator", "booster"]
  |> Enum.each(fn facet ->
    File.read!("#{__DIR__}/../config/facets/#{facet}.json")
    |> Jason.decode!()
    |> (fn list ->
          def unquote(:"#{facet}_list")(),
            do: unquote(list |> Enum.map(fn {key, _} -> key end) |> List.flatten())

          list
        end).()
    |> Enum.each(fn {word, value} ->
      @doc """
      Evaluates if a word/emoji is a **#{facet}** and returns value.

          iex> Veritaserum.Evaluator.evaluate_#{facet}("#{word}")
          #{value}
      """
      def unquote(:"evaluate_#{facet}")(unquote(word)), do: unquote(value)
    end)

    def unquote(:"evaluate_#{facet}")(_), do: nil
  end)
end
