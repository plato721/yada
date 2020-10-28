# frozen_string_literal: true

module SearchSupport
  class ResultsBuilder
    attr_accessor :results, :errors
    attr_reader :user, :search_params

    def initialize(user:, search_params:, scope:)
      @user = user
      @search_params = search_params
      @results = scope
    end

    def cache_key
      {
        search_params: search_params.to_h,
        quotes_updated: Quote.maximum(:updated_at)
      }
    end

    def complete!
      @completed = true
    end

    def complete?
      !!@completed
    end
  end
end
