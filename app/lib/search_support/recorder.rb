# frozen_string_literal: true

module SearchSupport
  class Recorder
    class << self
      def execute(results, search_params)
        search = Search.where(criteria: search_criteria(search_params).downcase)
                       .first_or_create
        search_params["user"].searches << search
        results
      end

      private

      def search_criteria(search_params)
        search_params['match_text'] || ''
      end
    end
  end
end
