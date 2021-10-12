defmodule Veritaserum.Mixfile do
  use Mix.Project

  @source_url "https://github.com/uesteibar/veritaserum"
  @version "0.2.2"

  def project do
    [
      app: :veritaserum,
      version: @version,
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: Coverex.Task],
      aliases: aliases(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp package do
    [
      description: "Sentiment analysis based on afinn-165, emojis and some enhancements.",
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
      maintainers: ["Unai Esteibar <uesteibar@gmail.com>"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [title: "Changelog"],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      logo: "veritaserum_logo.png",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:coverex, "~> 1.4", only: :test}
    ]
  end

  defp aliases do
    [
      test: "test --cover"
    ]
  end
end
