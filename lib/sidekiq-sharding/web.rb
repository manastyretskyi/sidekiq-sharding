# frozen_string_literal: true

require "tilt/erb"

require "sidekiq-sharding"
require_relative "web/helpers"

module SidekiqSharding
  module Web
    def self.registered(app) # rubocop:disable Metrics/AbcSize
      app.helpers do
        include Web::Helpers
      end

      app.get "/sharding" do
        @shards = SidekiqSharding.redis_shards_configs.keys
        @current_shard = session[SHARD_COOKIES_KEY]&.to_sym

        erb unique_template(:sharding)
      end

      app.post "/sharding/change-shard" do
        request.session[SHARD_COOKIES_KEY.to_sym] = params[:shard].to_s

        redirect "#{root_path}sharding"
      end
    end
  end
end

require_relative "extensions/web"
