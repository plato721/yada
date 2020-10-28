# frozen_string_literal: true

module SearchSupport
  class Sorter
    include SearchSupport::ExceptionHandler

    class << self
      def execute(results_builder)
        sort_params = results_builder.search_params['sort']
        return unless sort_params.present?

        results = results_builder.results
                                 .order(body: sort_params['body'].to_sym)
        results_builder.results = results
      rescue StandardError => e
        record_errors_and_terminate(e, results_builder)
      end
    end
  end
end
