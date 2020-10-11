class SeinfeldApiClient
  attr_reader :data, :error_message

  def initialize(options={})
    @options = default_options.merge(options)
  end

  def default_options
    {
      method: :get,
      url: 'https://seinfeld-quotes.herokuapp.com/quotes',
      timeout: 5
    }
  end

  def execute
    response = RestClient::Request.execute(@options)
    @data = JSON.parse(response.body)
    validate_data
  rescue StandardError => e
    @error_message = "#{e.class}: e.message"
    @data = nil

    backtrace = e.backtrace.join("\n")
    Rails.logger.error { "#{@error_message}\n#{backtrace}"}
  end

  def validate_data
    keys_found = data["quotes"].first
    ["quote", "author", "season", "episode", "image"].each do |expected_key|
      if keys_found.none? { |actual_key| actual_key == expected_key }
        @error_message = "Received unexpected data"
        return false
      end
    end
  rescue StandardError => e
    @error_message = "#{e.class}: e.message"

    backtrace = e.backtrace.join("\n")
    Rails.logger.error { "#{@error_message}\n#{backtrace}"}
  end
end
