# frozen_string_literal: true

module SearchSupport
  class Recorder
    class << self
      def execute(results_builder)
        search = Search.where(criteria: search_criteria(results_builder).downcase)
                       .first_or_create
        results_builder.user.searches << search
      end

      private

      def search_criteria(results_builder)
        results_builder.search_params['match_text'] || ''
      end
    end
  end
end
