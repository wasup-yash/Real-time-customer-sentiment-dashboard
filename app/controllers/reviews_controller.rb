class ReviewsController < ApplicationController
  def create
    ReviewIngestJob.perform_later(
      review_params[:body],
      author: review_params[:author].presence || "Guest",
      source: "Manual entry",
      rating: review_params[:rating].presence
    )

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to root_path, notice: "Review queued for analysis." }
    end
  end

  private

  def review_params
    params.require(:review).permit(:body, :author, :rating)
  end
end

