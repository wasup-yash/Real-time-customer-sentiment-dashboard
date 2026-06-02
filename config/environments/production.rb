require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.year.to_i}" }
  config.active_job.queue_adapter = :async
  config.force_ssl = ENV["RAILS_FORCE_SSL"] == "true"
  config.log_level = :info
end

