# frozen_string_literal: true

module SidekiqSharding
  module_function

  SHARD_COOKIES_KEY = "sidekiq-sharding:current-shard"

  class ConnectionError < StandardError; end

  def config
    @config ||= reset!
  end

  def configure(options = {})
    if block_given?
      yield config
    else
      options.each do |key, val|
        config.send("#{key}=", val)
      end
    end
  end

  def reset!
    @config = SidekiqSharding::Config.default
  end

  def use(shard:)
    if shard.nil? || (redis_config = shard_config(shard: shard.to_sym)).nil?
      yield
    else
      original_redis = Sidekiq.redis_pool
      new_pool = Sidekiq::RedisConnection.create({
        size: 5,
        logger: Sidekiq.default_configuration.logger,
        pool_name: shard.to_s
      }.merge(redis_config))

      begin
        Thread.current[:sidekiq_redis_pool] = new_pool

        begin
          Sidekiq.redis(&:ping)
        rescue StandardError
          raise ConnectionError
        end

        result = yield

        result
      ensure
        Thread.current[:sidekiq_redis_pool] = original_redis
        new_pool.shutdown(&:quit)
      end
    end
  end

  def redis_shards_configs
    config.redis_shards_configs
  end

  def shard_config(shard:)
    redis_shards_configs[shard]
  end
end
