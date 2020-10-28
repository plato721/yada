# frozen_string_literal: true

module SearchSupport
  class Orchestrator
    attr_reader :results

    def initialize(search_params:, user:)
      @results = SearchSupport::Results.new(
        user: user,
        scope: initial_scope,
        search_params: search_params.freeze
      )
    end

    STEPS = [
      SearchSupport::Searcher,
      SearchSupport::Filterer,
      SearchSupport::Sorter,
      SearchSupport::Recorder
    ].freeze

    def errors
      results.errors
    end

    def quotes
      results.scope
    end

    def search
      return if set_from_cache

      STEPS.each do |step_klass|
        return if errors.present?

        step_klass.new(results).execute
      end

      Rails.cache.write(results, results.scope) if errors.blank?
    end

    private

    def set_from_cache
      if quotes = Rails.cache.read(results)
        results.scope = quotes
      end
    end

    def initial_scope
      Quote.includes(:character, :episode, :season)
    end
  end
end
