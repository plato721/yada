# frozen_string_literal: true

module SearchSupport
  class Searcher
    class << self
      def execute(results, search_params)
        results.where('body ILIKE ?', "%#{match_text(search_params)}%")
      end

      private

      def match_text(search_params)
        search_params['match_text'] || ''
      end
    end
  end
end
