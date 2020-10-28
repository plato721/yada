# frozen_string_literal: true

module SearchSupport
  class Sorter
    def initialize(results)
      @results = results
    end

    def sort_params
      @results.search_params['sort']
    end

    def execute
      return unless sort_params.present?

      @results.scope = @results.scope
                               .order(
                                 body: sort_params['body'].to_sym
                               )
    rescue StandardError => e
      message = 'Bad sort attempted'
      backtrace = e.backtrace.join("\n")
      full_message = "#{message}\n#{e.message}\n#{backtrace}"

      @results.errors << message
      Rails.logger.error { full_message }
    end
  end
end
