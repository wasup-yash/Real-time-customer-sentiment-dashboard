require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "summary counts flagged and sentiment distribution" do
    Review.create!(
      author: "Avery",
      source: "Test",
      body: "Support was fantastic",
      sentiment: :positive,
      score: 0.9,
      emotions: { satisfaction: 1.0 },
      flagged: false
    )

    Review.create!(
      author: "Jordan",
      source: "Test",
      body: "I am furious about the broken refund flow",
      sentiment: :negative,
      score: 0.95,
      emotions: { anger: 1.0 },
      flagged: true
    )

    summary = Review.summary

    assert_equal 2, summary.fetch(:total)
    assert_equal 1, summary.fetch(:positive)
    assert_equal 1, summary.fetch(:negative)
    assert_equal 1, summary.fetch(:flagged)
    assert_equal 50, summary.fetch(:negative_rate)
  end
end

