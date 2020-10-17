class Search::Filterer
  attr_reader :quotes, :filters, :errors

  def initialize(quotes:, filters:)
    @quotes = quotes
    @filters = filters
    @errors = []
  end

  def filter
    running_quotes = filter_only(self.quotes)
    filter_not(running_quotes)
  end

  def filter_not(quotes)
    not_filters = filters["not"]
    return quotes unless not_filters

    characters = not_filters["characters"]
    return quotes unless characters

    quotes.where.not(characters: { name: characters })
  end

  def filter_only(quotes)
    only_filters = filters["only"]
    return quotes unless only_filters

    characters = only_filters["characters"]
    return quotes unless characters

    quotes.where(characters: { name: characters })
  end
end
