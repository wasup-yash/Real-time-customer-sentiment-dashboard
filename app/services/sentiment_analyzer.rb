require "json"
require "open3"

class SentimentAnalyzer
  POSITIVE_WORDS = %w[
    excellent fantastic smooth helpful patient quick quickly fixed love great good clear reliable happy
  ].freeze

  NEGATIVE_WORDS = %w[
    angry anxious broken damaged deleted disappointed failing frustrated furious ignored issue late poor refund timeout warning
  ].freeze

  EMOTION_WORDS = {
    anger: %w[angry furious ignored broken refund],
    frustration: %w[frustrated failing timeout repeated issue],
    anxiety: %w[anxious confusing warning delayed],
    disappointment: %w[disappointed damaged deleted poor late],
    satisfaction: %w[excellent fantastic smooth helpful fixed love great happy]
  }.freeze

  def self.call(text)
    new(text).call
  end

  def initialize(text)
    @text = text.to_s
  end

  def call
    classifier_result || lexical_result
  end

  private

  attr_reader :text

  def classifier_result
    script_path = Rails.root.join("scripts", "sentiment_classifier.py")
    python = ENV.fetch("PYTHON", "python")
    stdout, _stderr, status = Open3.capture3(python, script_path.to_s, stdin_data: JSON.generate(text: text))
    return unless status.success?

    parsed = JSON.parse(stdout, symbolize_names: true)
    normalize(parsed)
  rescue Errno::ENOENT, JSON::ParserError
    nil
  end

  def lexical_result
    tokens = text.downcase.scan(/[a-z']+/)
    positive_hits = tokens.count { |token| POSITIVE_WORDS.include?(token) }
    negative_hits = tokens.count { |token| NEGATIVE_WORDS.include?(token) }
    raw_score = positive_hits - negative_hits

    sentiment =
      if raw_score.negative?
        :negative
      elsif raw_score.positive?
        :positive
      else
        :neutral
      end

    confidence = [[0.55 + raw_score.abs * 0.08, 0.55].max, 0.98].min.round(3)

    {
      sentiment: sentiment,
      score: confidence,
      emotions: emotion_scores(tokens),
      flagged: sentiment == :negative
    }
  end

  def normalize(result)
    sentiment = result.fetch(:sentiment, "neutral").to_s.downcase.to_sym
    sentiment = :neutral unless Review.sentiments.key?(sentiment.to_s)

    {
      sentiment: sentiment,
      score: result.fetch(:score, 0.55).to_f.clamp(0.0, 1.0).round(3),
      emotions: result.fetch(:emotions, {}),
      flagged: result.fetch(:flagged, sentiment == :negative)
    }
  end

  def emotion_scores(tokens)
    raw = EMOTION_WORDS.transform_values do |words|
      tokens.count { |token| words.include?(token) }
    end

    max = [raw.values.max, 1].max.to_f
    raw.transform_values { |value| (value / max).round(2) }
  end
end

