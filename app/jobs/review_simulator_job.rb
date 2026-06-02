class ReviewSimulatorJob < ApplicationJob
  queue_as :default

  DELAY = 2.seconds

  def perform(token:)
    return unless Rails.cache.read("review_simulator_token") == token

    sample = ReviewSampleGenerator.next
    ReviewIngestJob.perform_later(
      sample.fetch(:body),
      author: sample.fetch(:author),
      source: sample.fetch(:source),
      rating: sample.fetch(:rating)
    )

    self.class.set(wait: DELAY).perform_later(token: token)
  end
end

