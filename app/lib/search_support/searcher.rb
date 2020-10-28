# frozen_string_literal: true

module SearchSupport
  class Searcher
    def initialize(results)
      @results = results
    end

    def match_text
      @results.search_params['match_text'] || ''
    end

    def execute
      @results.scope = @results.scope
                               .where('body ILIKE ?', "%#{match_text}%")
    rescue StandardError => e
      message = 'Bad search attempted'
      backtrace = e.backtrace.join("\n")
      full_message = "#{message}\n#{e.message}\n#{backtrace}"

      @results.errors << message
      Rails.logger.error { full_message }
    end
  end
end
