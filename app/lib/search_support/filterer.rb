# frozen_string_literal: true

module SearchSupport
  class Filterer
    class << self
      def execute(results, search_params)
        filters = search_params['filters']
        return results unless filters.present?

        results = filter_only(filters, results)
        filter_not(filters, results)
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
