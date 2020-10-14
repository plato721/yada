class Search::Orchestrator
  attr_reader :search_params, :errors, :quotes

  def initialize(search_params)
    @search_params = search_params
    @errors = []
  end

  def search
    @quotes = Quote.where('body LIKE ?', search_params["match_text"])
  end
end
