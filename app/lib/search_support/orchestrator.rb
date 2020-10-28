# frozen_string_literal: true

module SearchSupport
  class Orchestrator
    attr_reader :errors

    STEPS = [
        SearchSupport::CacheReader,
        SearchSupport::Searcher,
        SearchSupport::Filterer,
        SearchSupport::Sorter,
        SearchSupport::CacheWriter
    ].freeze

    def initialize(search_params:, user:)
      @results_builder = SearchSupport::ResultsBuilder.new(
        scope: initial_scope,
        user: user,
        search_params: search_params.freeze
      )
    end

    def initial_scope
      Quote.includes(:character, :episode, :season)
    end

    # The results_builder holds a results which is a scope that continues to be whittled
    # down as the pipeline moves. If the completed flag is set, the loop stops. If errors
    # are present, errors are set on this the Orchestrator object. Otherwise, the whittled
    # down scope is returns.
    def search
      STEPS.each do |step_klass|
        step_klass.execute(results_builder)
        break if results_builder.complete?
      end

      record_search
      if results_builder.errors.blank?
        results_builder.results
      else
        @errors = results_builder.errors
        false
      end
    end

    def record_search
      SearchSupport::Recorder.execute(results_builder)
    end

    attr_reader :results_builder
  end
end
