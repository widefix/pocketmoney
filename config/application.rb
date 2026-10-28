require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BudgetingKid
  class Application < Rails::Application
    # Initialize configuration defaults for Rails 7.2.
    config.load_defaults 7.2

    # Resolve the client IP before throttling, and reject scans before the
    # exception-reporting middleware or application controllers run.
    config.middleware.move_after ActionDispatch::RemoteIp, Rack::Attack

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'get.budgetingkid.com'
        resource '/subscribers', headers: :any, methods: [:post, :options]
      end
    end
  end
end
