class Search::Orchestrator
  attr_reader :results

  def initialize(search_params:, user:)
    @results = Search::Results.new(
      user: user,
      scope: initial_scope,
      search_params: search_params
    )
  end

  STEPS = [
    Search::Searcher,
    Search::Filterer,
    Search::Sorter,
    Search::Recorder,
  ]

  def errors
    results.errors
  end

  def quotes
    results.scope
  end

  def search
    STEPS.each do |step_klass|
      return if errors.present?
      step_klass.new(results).execute
    end
  end

  def initial_scope
    Quote.includes(:character, :episode, :season)
  end
end
