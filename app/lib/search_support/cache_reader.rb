# frozen_string_literal: true

module SearchSupport
  class CacheReader
    include SearchSupport::ExceptionHandler

    class << self
      def execute(results_builder)
        results = read_cache(results_builder)
        if results.present?
          results_builder.results = results
          results_builder.complete!
        end
      rescue StandardError => e
        record_errors_and_terminate(e, results_builder)
      end

      private

      def read_cache(results_builder)
        Rails.cache.read(results_builder)
      end
    end
  end
end
