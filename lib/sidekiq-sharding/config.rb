# frozen_string_literal: true

module SidekiqSharding
  ThreadSafeConfig = Concurrent::MutableStruct.new("ThreadSafeConfig",
                                                   :redis_shards_configs)

  class Config < ThreadSafeConfig
    def self.default
      new({})
    end
  end
end
