require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  config.active_job.queue_adapter = :async

  config.assets.configure do |env|
    env.cache = ActiveSupport::Cache.lookup_store(:memory_store)
  end
  config.assets.quiet = true
end
