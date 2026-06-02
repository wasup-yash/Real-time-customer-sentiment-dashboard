class SimulatorController < ApplicationController
  def start
    token = SecureRandom.hex(12)
    Rails.cache.write("review_simulator_token", token)
    ReviewSimulatorJob.perform_later(token: token)

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to root_path, notice: "Review simulator started." }
    end
  end

  def stop
    Rails.cache.delete("review_simulator_token")

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to root_path, notice: "Review simulator stopped." }
    end
  end
end

