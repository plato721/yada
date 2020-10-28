# frozen_string_literal: true

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
      visual_log('Starting quote fetch!')
      fetcher.execute
      if fetcher.error_message.present?
        log_errors
        return false
      end

      visual_log('Quote fetch successful. Loading into db!')
      # TODO: - clear the api caches
      fetcher.data['quotes'].each do |row|
        attributes = @transformer.transform(row)
        Quote.create(attributes)
      end

      visual_log('...Quote load complete...')
    end

    def visual_log(message, level = :info)
      puts message
      Rails.logger.send(level) { message }
    end

    def log_errors
      message = "Problem with ETL due to fetcher error: #{fetcher.error_message}"
      visual_log(message, :error)
    end
  end
end
