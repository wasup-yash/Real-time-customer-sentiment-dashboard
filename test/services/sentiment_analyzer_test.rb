require "test_helper"

class SentimentAnalyzerTest < ActiveSupport::TestCase
  test "flags clearly negative text" do
    result = SentimentAnalyzer.call("I am furious that support ignored my broken refund request")

    assert_equal :negative, result.fetch(:sentiment)
    assert result.fetch(:flagged)
    assert_operator result.fetch(:score), :>=, 0.55
  end

  test "detects positive text" do
    result = SentimentAnalyzer.call("Fantastic support fixed my issue quickly")

    assert_equal :positive, result.fetch(:sentiment)
    assert_not result.fetch(:flagged)
  end
end

