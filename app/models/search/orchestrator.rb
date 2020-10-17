class Search::Orchestrator
  attr_reader :search_params, :errors, :quotes, :recorder, :user

  def initialize(
    search_params:,
    user:,
    recorder: nil, filter_class: nil)
    @user = user
    @search_params = search_params
    @errors = []
    @recorder = recorder || Search::Recorder.new
    @filter_class = filter_class || Search::Filterer
  end

  def search
    @quotes = initial_search
    return if errors.present?

    @quotes = apply_filters(@quotes)
    return if errors.present?

    recorder.record(user, search_params["match_text"])
    @quotes
  end

  def apply_filters(quotes)
    filters = search_params["filters"]
    return quotes unless filters.present?

    filterer = @filter_class.new(quotes: quotes, filters: filters)
    return filterer.filter unless filterer.errors.present?

    @errors << filterer.errors
  end

  def initial_search
    Quote.includes(:character, :episode, :season)
         .where('body ILIKE ?', "%#{search_params["match_text"]}%")
  end
end
