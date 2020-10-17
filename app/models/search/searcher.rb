class Search::Searcher
  def initialize(results)
    @results = results
  end

  def match_text
    @results.search_params["match_text"] || ""
  end

  def execute
    @results.scope = @results.scope
      .where('body ILIKE ?', "%#{match_text}%")

  rescue StandardError => e
    message = "Bad search attempted"
    full_message = "#{message}\n#{e.message}\n#{e.backtrace}"

    @results.errors << message
    Rails.logger.error { message }
  end
end
