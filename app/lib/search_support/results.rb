# frozen_string_literal: true

module SearchSupport
  class Results
    attr_accessor :scope
    attr_reader :user, :search_params, :errors

    def initialize(user:, search_params:, scope:)
      @user = user
      @search_params = search_params
      @scope = scope
      @errors = []
    end

    def add_error(error)
      @errors << error
    end

    def cache_key
      {
        search_params: search_params.to_h,
        quotes_updated: Quote.maximum(:updated_at)
      }
    end
  end
end
