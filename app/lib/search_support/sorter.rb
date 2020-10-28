# frozen_string_literal: true

module SearchSupport
  class Sorter
    class << self
      def execute(results, search_params)
        sort_params = search_params['sort']
        return results unless sort_params.present?

        results.order(body: sort_params['body'].to_sym)
      end
    end
  end
end
