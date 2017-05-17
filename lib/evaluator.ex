defmodule Veritaserum.Evaluator do
  ["word", "negator", "booster"]
  |> Enum.each(fn domain ->
    File.read!("#{__DIR__}/../config/#{domain}.json")
    |> Poison.Parser.parse!
    |> Enum.each(fn {word, value} ->

      @doc """
      Evaluates if a word/emoji is a **#{domain}** and returns value.

          iex> Veritaserum.Evaluator.evaluate_#{domain}("#{word}")
          #{value}
      """
      def unquote(:"evaluate_#{domain}")(unquote(word)), do: unquote(value)
    end)

    def unquote(:"evaluate_#{domain}")(_), do: 0
  end)
end
