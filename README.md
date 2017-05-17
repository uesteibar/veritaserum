# Veritaserum

[![Build Status](https://travis-ci.org/uesteibar/veritaserum.svg?branch=master)](https://travis-ci.org/uesteibar/veritaserum)

Simple sentiment analysis for [Elixir](http://elixir-lang.org/) based on the AFINN-165 list and some extra enhancements.

It also supports:
- **emojis** (❤️, 😱...)
- **boosters** (*very*, *really*...)
- **negators** (*don't*, *not*...).

## Index

- [Installation](#installation)
- [Usage](#usage)
- [Running Locally](#running-locally)
- [Contributing](#contributing)

## Installation

Add `veritaserum` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:veritaserum, "~> 0.1.1"}]
end
```

## Usage

To analyze a text
```elixir
Veritaserum.analyze("I love Veritaserum!") #=> 3

# It also supports emojis
Veritaserum.analyze("I ❤️ Veritaserum!") #=> 2

# It also supports negators
Veritaserum.analyze("I like Veritaserum!") #=> 2
Veritaserum.analyze("I don't like Veritaserum!") #=> -2

#and boosters
Veritaserum.analyze("Veritaserum is cool!") #=> 1
Veritaserum.analyze("Veritaserum is very cool!") #=> 2
```

You can also pass a list
```elixir
Veritaserum.analyze(["I love Veritaserum!", "I hate some things!"]) #=> [3, -3]
```

Documentation can be found on [HexDocs](https://hexdocs.pm/veritaserum).

## Running locally

Clone the repository
```bash
git clone git@github.com:uesteibar/veritaserum.git
```

Install dependencies
```bash
cd veritaserum
mix deps.get
```

To run the tests
```bash
mix test
```

To run the lint
```elixir
mix credo
```

## Contributing

Pull requests are always welcome =)

The project uses [standard-version](https://github.com/conventional-changelog/standard-version) to update the [Changelog](https://github.com/uesteibar/veritaserum/blob/master/CHANGELOG.md) with each commit message and upgrade the package version.
For that reason every contribution should have a title and body that follows the [conventional commits standard](https://conventionalcommits.org/) conventions (e.g. `feat(analyzer): Make it smarter than Jarvis`).

To make this process easier, you can do the following:

Install `commitizen` and `cz-conventional-changelog` globally
```bash
npm i -g commitizen cz-conventional-changelog
```

Save `cz-conventional-changelog` as default
```bash
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
```

Instead of `git commit`, you can now run
```
git cz
```
and follow the instructions to generate the commit message.
