# frozen_string_literal: true

module SidekiqSharding
  module Middleware
    class Web
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ::Rack::Request.new(env)
        shard = request.session[SHARD_COOKIES_KEY]&.to_sym

        SidekiqSharding.use(shard: shard) do
          @app.call(env)
        end
      rescue SidekiqSharding::ConnectionError
        request.session[SHARD_COOKIES_KEY] = nil

        @app.call(env)
      end
    end
  end
end
