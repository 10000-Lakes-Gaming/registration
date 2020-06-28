require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PfsRegistration
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.active_record.raise_in_transactional_callbacks = true
    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :local

    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
