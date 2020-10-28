# frozen_string_literal: true

module SearchSupport
  class Filterer
    include SearchSupport::ExceptionHandler

    class << self
      def execute(results_builder)
        filters = results_builder.search_params['filters']
        return unless filters.present?

        results = filter_only(filters, results_builder.results)
        results = filter_not(filters, results)
        results_builder.results = results
      rescue StandardError => e
        record_errors_and_terminate(e, results_builder)
      end

      private

      def filter_not(filters, results)
        characters = filters.try(:[], 'not').try(:[], 'characters')
        return results unless characters

        results.where.not(characters: { name: characters })
      end

      def filter_only(filters, results)
        characters = filters.try(:[], 'only').try(:[], 'characters')
        return results unless characters

        results.where(characters: { name: characters })
      end
    end
  end
end
