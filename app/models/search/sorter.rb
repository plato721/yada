class Search::Sorter
  attr_reader :quotes, :sort_params, :errors

  def initialize(quotes:, sort_params:)
    @quotes = quotes
    @sort_params = sort_params
    @errors = []
  end

  def sort
    return quotes unless sort_params.present?

    quotes.order(body: sort_params["body"].to_sym)

  rescue StandardError => e
      @errors << "Unsupported sort"
      error_message = "#{e.message}\n#{e.backtrace}"
      Rails.logger.debug("Bad sort attempt\n#{error_message}")
      false
  end
end
