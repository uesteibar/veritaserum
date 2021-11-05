defmodule Veritaserum.Mixfile do
  use Mix.Project

  @version "0.2.2"

  def project do
    [
      app: :veritaserum,
      version: @version,
      elixir: "~> 1.3",
      description: "Sentiment analysis based on afinn-165, emojis and some enhancements.",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: Coverex.Task],
      aliases: aliases(),
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: github()
    ]
  end

  def application do
    [extra_applications: [:logger, :jason]]
  end

  defp package do
    [
      files: [
        "config/facets/word.json",
        "config/facets/negator.json",
        "config/facets/booster.json",
        "config/facets/emoticon.json",
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE.md"
      ],
      links: %{"github" => github()},
      maintainers: ["Unai Esteibar <uesteibar@gmail.com>"],
      licenses: ["Apache 2.0"]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "Veritaserum",
      logo: "veritaserum_logo.png",
      extras: ["README.md"]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:coverex, "~> 1.4", only: :test}
    ]
  end

  defp aliases do
    [
      test: "test --cover"
    ]
  end

  defp github do
    "https://github.com/uesteibar/veritaserum"
  end
end
