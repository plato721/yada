# frozen_string_literal: true

module SearchSupport
  class CacheWriter
    def initialize(results)
      @results = results
    end

    def execute
      Rails.cache.write(results, results.scope)
    end

    private

    attr_reader :results
  end
end
