# frozen_string_literal: true

module SearchSupport
  class Searcher
    include SearchSupport::ExceptionHandler

    class << self
      def execute(results_builder)
        results = results_builder.results
                                 .where('body ILIKE ?', "%#{match_text(results_builder)}%")
        results_builder.results = results
      rescue StandardError => e
        record_errors_and_terminate(e, results_builder)
      end

      private

      def match_text(results_builder)
        results_builder.search_params['match_text'] || ''
      end
    end
  end
end
