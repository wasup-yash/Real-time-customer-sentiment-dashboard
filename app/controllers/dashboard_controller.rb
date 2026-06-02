class DashboardController < ApplicationController
  def index
    @reviews = Review.recent.limit(30)
    @summary = Review.summary
    @review = Review.new
  end
end

