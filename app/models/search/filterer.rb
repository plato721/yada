class Search::Filterer
  def initialize(results)
    @results = results
  end

  def execute
    filter_only
    filter_not
  end

  def filters
    @filters ||= @results.search_params["filters"]
  end

  def filter_not
    characters = filters.try(:[], "not").try(:[], "characters")
    return unless characters

    @results.scope = @results.scope
                      .where.not(characters: { name: characters })
  end

  def filter_only
    characters = filters.try(:[], "only").try(:[], "characters")
    return unless characters

    @results.scope = @results.scope
                      .where(characters: { name: characters })
  end
end
