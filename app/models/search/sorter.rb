class Search::Sorter
  def initialize(results)
    @results = results
  end

  def sort_params
    @results.search_params["sort"]
  end

  def execute
    return unless sort_params.present?

    @results.scope = @results.scope
                        .order(
                          body: sort_params["body"].to_sym
                        )

  rescue StandardError => e
      @results.errors << "Unsupported sort"
      error_message = "#{e.message}\n#{e.backtrace}"
      Rails.logger.debug("Bad sort attempt\n#{error_message}")
      false
  end
end
