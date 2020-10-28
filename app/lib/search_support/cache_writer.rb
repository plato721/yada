# frozen_string_literal: true

module SearchSupport
  class CacheWriter
    class << self
      def execute(results, search_params)
        Rails.cache.write(cache_key(search_params), results)
        results
      end

      private

      def cache_key(search_params)
        userless_params = search_params.clone
        userless_params.delete("user")
        {
            search_params: userless_params.to_h,
            quotes_updated: Quote.maximum(:updated_at)
        }
      end
    end
  end
end
