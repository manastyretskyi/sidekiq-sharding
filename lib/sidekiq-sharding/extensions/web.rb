# frozen_string_literal: true

require "sidekiq/web" unless defined?(Sidekiq::Web)
require "sidekiq-sharding/middleware/web"

Sidekiq::Web.tabs["sharding"] = "sharding"

Sidekiq::Web.locales << File.expand_path("#{File.dirname(__FILE__)}/../web/locales")

Sidekiq::Web.register(SidekiqSharding::Web)
Sidekiq::Web.use SidekiqSharding::Middleware::Web
