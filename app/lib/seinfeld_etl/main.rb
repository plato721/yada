# frozen_string_literal: true

module SeinfeldEtl
  class Main
    def initialize(fetcher:, transformer:)
      @fetcher = fetcher
      @transformer = transformer
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

    private

    def visual_log(message, level = :info)
      puts message
      Rails.logger.send(level) { message }
    end

    def log_errors
      message = "Problem with ETL due to fetcher error: #{fetcher.error_message}"
      visual_log(message, :error)
    end

    attr_reader :fetcher, :transformer
  end
end
