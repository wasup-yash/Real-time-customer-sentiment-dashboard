ReviewSampleGenerator::SAMPLES.first(5).each do |sample|
  ReviewIngestJob.perform_now(
    sample.fetch(:body),
    author: sample.fetch(:author),
    source: sample.fetch(:source),
    rating: sample.fetch(:rating)
  )
end

