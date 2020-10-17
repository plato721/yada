class Search::Results
  attr_accessor :scope
  attr_reader :user, :search_params, :errors

  def initialize(user:, search_params:, scope:)
    @user = user
    @search_params = search_params
    @scope = scope
    @errors = []
  end

  def add_error(error)
    @errors << error
  end
end
