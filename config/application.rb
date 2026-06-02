require_relative "boot"

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module CustomerSentimentDashboard
  class Application < Rails::Application
    config.load_defaults 7.1

    config.time_zone = "UTC"
    config.active_job.queue_adapter = :async
  end
end
