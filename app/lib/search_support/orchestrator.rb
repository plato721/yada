# frozen_string_literal: true

module SearchSupport
  class Orchestrator
    attr_reader :errors

    def initialize(search_params:, user:)
      @search_params = search_params.merge({user: user})
    end

    STEPS = [
      SearchSupport::Searcher,
      SearchSupport::Filterer,
      SearchSupport::Sorter,
      SearchSupport::Recorder,
      SearchSupport::CacheWriter
    ].freeze

    def search
      cached_result = read_cache
      return cached_result if cached_result

      STEPS.reduce(initial_scope) do |results, step_klass|
        @current_step = step_klass
        step_klass.execute(results, search_params)
      end
    rescue StandardError => e
      friendly_step_name = current_step.to_s.gsub('SearchSupport::', '')
      message = "Bad search attempted. Failed in #{friendly_step_name}"
      backtrace = e.backtrace.join("\n")
      full_message = "#{message}\n#{e.message}\n#{backtrace}"

      @errors = message
      Rails.logger.error { full_message }
      false
    end

    private

    def read_cache
      userless_params = search_params.clone
      userless_params.delete("user")
      Rails.cache.read(userless_params)
    end

    def initial_scope
      Quote.includes(:character, :episode, :season)
    end

    attr_reader :search_params, :current_step
  end
end
