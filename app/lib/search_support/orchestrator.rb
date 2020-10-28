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

    # The results_builder holds a results which is a scope that continues to be narrowed
    # and transformed as the pipeline moves. If the completed flag is set, the loop stops.
    # If no errors are present, the narrowed scope is returned. Otherwise, false is returned
    # and errors are set to be read from this object.
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

    private

    attr_reader :results_builder

    def record_search
      SearchSupport::Recorder.execute(results_builder)
    end

    def initial_scope
      Quote.includes(:character, :episode, :season)
    end
  end
end
