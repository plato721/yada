module SeinfeldEtl
  class Main
    attr_reader :fetcher, :transformer

    def initialize(fetcher: nil)
      @fetcher = fetcher || default_fetcher
      @transformer = Transformer.new
    end

    def default_fetcher
      ::SeinfeldApiClient.new
    end

    def execute
      fetcher.execute
      return log_errors if fetcher.error_message.present?

      # TODO - clear the api caches
      fetcher.data["quotes"].each do |row|
        attributes = @transformer.transform(row)
        Quote.create(attributes)
      end
    end

    def log_errors
      message = "Problem with ETL due to fetcher error #{fetcher.error_message}"
      Rails.logger.error { message }
    end
  end
end
