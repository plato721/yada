module SeinfeldEtl
  class Main
    def initialize(fetcher:, transformer:)
      @fetcher = fetcher
      @transformer = transformer
    end

    def execute
      final_log transform fetch
    rescue StandardError => e
      log_error(e)
      false
    end

    private

    def fetch
      visual_log('Starting quote fetch!')
      fetcher.execute
    end

    def transform(data)
      visual_log('Quote fetch successful. Loading into db!')

      # TODO: - clear the api caches
      data['quotes'].map do |row|
        Quote.create transformer.transform(row)
      end
    end

    def final_log(quotes)
      visual_log("...Created #{quotes.count} quotes. Done!...")
      quotes
    end

    def visual_log(message, level = :info)
      puts message
      Rails.logger.send(level) { message }
    end

    def log_error(error)
      message = "Problem with ETL: #{error.message}\n"
      message << error.backtrace.join("\n")
      visual_log(message, :error)
    end

    attr_reader :fetcher, :transformer
  end
end
