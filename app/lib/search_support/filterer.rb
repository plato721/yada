# frozen_string_literal: true

module SearchSupport
  class Filterer
    def initialize(results)
      @results = results
    end

    def execute
      filter_only
      filter_not
    rescue StandardError => e
      message = 'Bad filter attempted'
      backtrace = e.backtrace.join("\n")
      full_message = "#{message}\n#{e.message}\n#{backtrace}"

      @results.errors << message
      Rails.logger.error { full_message }
    end

    def filters
      @filters ||= @results.search_params['filters']
    end

    def filter_not
      characters = filters.try(:[], 'not').try(:[], 'characters')
      return unless characters

      @results.scope = @results.scope
                               .where.not(characters: { name: characters })
    end

    def filter_only
      characters = filters.try(:[], 'only').try(:[], 'characters')
      return unless characters

      @results.scope = @results.scope
                               .where(characters: { name: characters })
    end
  end
end
