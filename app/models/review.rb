class Review < ApplicationRecord
  enum sentiment: { unknown: 0, negative: 1, neutral: 2, positive: 3 }

  serialize :emotions, coder: JSON

  validates :body, presence: true, length: { maximum: 1_200 }
  validates :author, presence: true
  validates :source, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  scope :recent, -> { order(created_at: :desc) }
  scope :flagged, -> { where(flagged: true) }

  after_create_commit :broadcast_new_review

  def self.summary
    total = count
    counts = group(:sentiment).count
    flagged_count = flagged.count

    {
      total: total,
      negative: sentiment_count(counts, :negative),
      neutral: sentiment_count(counts, :neutral),
      positive: sentiment_count(counts, :positive),
      flagged: flagged_count,
      negative_rate: total.positive? ? ((flagged_count.to_f / total) * 100).round : 0
    }
  end

  def primary_emotion
    (emotions&.max_by { |_emotion, value| value.to_f }&.first || "mixed").to_s
  end

  def self.sentiment_count(counts, sentiment)
    counts[sentiment.to_s] || counts[sentiments.fetch(sentiment.to_s)] || 0
  end
  private_class_method :sentiment_count

  private

  def broadcast_new_review
    broadcast_prepend_to "reviews", target: "reviews", partial: "reviews/review", locals: { review: self }
    broadcast_remove_to "reviews", target: "empty-reviews"
    broadcast_replace_to "metrics", target: "metrics", partial: "reviews/metrics", locals: { summary: Review.summary }

    return unless flagged?

    broadcast_prepend_to "alerts", target: "alerts", partial: "reviews/alert", locals: { review: self }
  end
end
