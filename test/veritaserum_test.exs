defmodule VeritaserumTest do
  use ExUnit.Case

  doctest Veritaserum

  import Veritaserum

  describe "when given a list" do
    @list ["I love Veritaserum", "I hate nothing"]

    test "calculates sentimental value for each" do
      assert analyze(@list) == [3, -3]
    end
  end

  describe "when text has no relevant word" do
    @text "I build Veritaserum"

    test "sentimental value is 0" do
      assert analyze(@text) == 0
    end
  end

  describe "when text has relevant word" do
    @text "I love Veritaserum"

    test "calculates sentimental value" do
      assert analyze(@text) == 3
    end
  end

  describe "when return option is :score_and_marks" do
    @text "You really love Veritaserum. Don't you?"

    test "returns score with marks" do
      result =
        {4,
         [
           {:neutral, 0, "you"},
           {:booster, 1, "really"},
           {:word, 3, "love"},
           {:neutral, 0, "veritaserum"},
           {:negator, 1, "don't"},
           {:neutral, 0, "you?"}
         ]}

      assert ^result = analyze(@text, return: :score_and_marks)
    end
  end

  describe "when text has relevant emoji" do
    @text "I ❤️ Veritaserum"

    test "calculates sentimental value" do
      assert analyze(@text) == 3
    end

    @text "I❤️Veritaserum"

    test "calculates sentimental value of emoji without spaces" do
      assert analyze(@text) == 3
    end
  end

  describe "when text has irrelevant characters" do
    @text "I love! Veritaserum"

    test "removes irrelevant characters" do
      assert analyze(@text) == 3
    end
  end

  describe "when text has negator" do
    @text "I don't hate Veritaserum"

    test "the negator flips the value of the next word" do
      assert analyze(@text) == 3
    end
  end

  describe "when positive word has booster" do
    @text "I really love Veritaserum"

    test "the booster increases the value of the next word" do
      assert analyze(@text) == 4
    end
  end

  describe "when negative word has booster" do
    @text "I really hate Veritaserum"

    test "the booster decreases the value of the next word" do
      assert analyze(@text) == -4
    end
  end

  describe "when irrelevant word has booster" do
    @text "I really buy Veritaserum"

    test "the booster does not affect the value of the next word" do
      assert analyze(@text) == 0
    end
  end
end
