# frozen_string_literal: true

module SearchSupport
  class CacheWriter
    include SearchSupport::ExceptionHandler

    class << self
      def execute(results_builder)
        Rails.cache.write(results_builder, results_builder.results)
      rescue StandardError => e
        record_errors_and_terminate(e, results_builder)
      end
    end
  end
end
