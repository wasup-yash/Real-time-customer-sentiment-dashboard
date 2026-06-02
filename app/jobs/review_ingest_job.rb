class ReviewIngestJob < ApplicationJob
  queue_as :default

  def perform(body, author: "Guest", source: "Simulator", rating: nil)
    result = SentimentAnalyzer.call(body)

    Review.create!(
      body: body,
      author: author,
      source: source,
      rating: rating,
      sentiment: result.fetch(:sentiment),
      score: result.fetch(:score),
      emotions: result.fetch(:emotions),
      flagged: result.fetch(:flagged)
    )
  end
end

