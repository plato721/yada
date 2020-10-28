# frozen_string_literal: true

module SearchSupport
  class Recorder
    def initialize(results)
      @results = results
    end

    def execute
      search = Search.where(criteria: search_criteria.downcase)
                     .first_or_create
      @results.user.searches << search
    end

    private

    def search_criteria
      @results.search_params['match_text'] || ''
    end
  end
end
