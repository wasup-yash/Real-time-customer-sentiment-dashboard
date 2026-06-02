class ReviewSampleGenerator
  SAMPLES = [
    {
      author: "Avery",
      source: "App Store",
      rating: 5,
      body: "The live chat agent fixed my billing issue quickly. This was the smoothest support experience I have had all year."
    },
    {
      author: "Jordan",
      source: "TrustPilot",
      rating: 1,
      body: "I am furious. My order arrived damaged, support ignored two emails, and the refund link is broken."
    },
    {
      author: "Morgan",
      source: "Zendesk",
      rating: 2,
      body: "The dashboard looks good, but exports keep failing and our team is frustrated by the repeated timeout errors."
    },
    {
      author: "Riley",
      source: "G2",
      rating: 4,
      body: "Setup took a little longer than expected, but the onboarding specialist was patient and helpful."
    },
    {
      author: "Casey",
      source: "Intercom",
      rating: 3,
      body: "The product works as described. I would like clearer notifications when background sync is delayed."
    },
    {
      author: "Taylor",
      source: "Twitter",
      rating: 1,
      body: "Really disappointed today. The new release deleted my saved filters and I cannot reach anyone in support."
    },
    {
      author: "Jamie",
      source: "Help Scout",
      rating: 5,
      body: "Fantastic response time. The replacement shipped the same day and the team followed up without me asking."
    },
    {
      author: "Quinn",
      source: "Capterra",
      rating: 2,
      body: "The recent invoice was confusing and made me anxious because the plan total changed without warning."
    }
  ].freeze

  def self.next
    SAMPLES.sample
  end
end

