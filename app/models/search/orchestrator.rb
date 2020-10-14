class Search::Orchestrator
  attr_reader :search_params, :errors, :quotes, :recorder, :user

  def initialize(search_params:, user:, recorder: nil)
    @user = user
    @search_params = search_params
    @errors = []
    @recorder = recorder || Search::Recorder.new
  end

  def search
    @quotes = Quote.where('body LIKE ?', search_params["match_text"])
    recorder.record(user, search_params["match_text"])
    @quotes
  end
end
