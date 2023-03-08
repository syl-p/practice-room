require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PracticeRoom
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.assets.check_precompiled_asset = false
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # errors routes
    config.exceptions_app = self.routes

    # Devise layouts
    config.to_prepare do
      Devise::SessionsController.layout "guest"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application" : "guest" }
      Devise::ConfirmationsController.layout "guest"
      Devise::UnlocksController.layout "guest"
      Devise::PasswordsController.layout "guest"
    end
  end
end
