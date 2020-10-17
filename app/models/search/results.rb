class Search::Results
  attr_accessor :quotes
  attr_reader :user, :search_params

  def initialize(user, search_params, quotes)
    @user = user
    @search_params = search_params
    @quotes = quotes
  end
end
