# frozen_string_literal: true

require "sidekiq"

require "concurrent/mutable_struct"

require_relative "sidekiq/sharding"
require_relative "sidekiq-sharding/version"
require_relative "sidekiq-sharding/config"
require_relative "sidekiq-sharding/sidekiq_sharding"
