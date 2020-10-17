class Search::Orchestrator
  attr_reader :search_params, :errors, :quotes, :recorder, :user

  def initialize(
      search_params:,
      user:,
      recorder: nil,
      filter_class: nil,
      sorter_class: nil)
    @user = user
    @search_params = search_params
    @errors = []
    @recorder = recorder || Search::Recorder.new
    @filter_class = filter_class || Search::Filterer
    @sorter_class = sorter_class || Search::Sorter
  end

  def search
    @quotes = initial_search
    return if errors.present?

    @quotes = apply_filters(@quotes)
    return if errors.present?

    @quotes = apply_sort(@quotes)
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

  def apply_sort(quotes)
    sort_params = search_params["sort"]
    return quotes unless sort_params.present?

    sorter = @sorter_class.new(quotes: quotes, sort_params: sort_params)
    return sorter.sort unless sorter.errors.present?

    @errors << sorter.errors
  end

  def initial_search
    Quote.includes(:character, :episode, :season)
         .where('body ILIKE ?', "%#{search_params["match_text"]}%")
  end
end
