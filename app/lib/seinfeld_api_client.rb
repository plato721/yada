# frozen_string_literal: true

class SeinfeldApiClient
  def initialize(rest_client: nil, url: nil)
    @rest_client = rest_client || default_rest_client
    @url = url || default_url
  end

  def execute
    validate parse fetch
  end

  private

  def fetch
    @rest_client.execute rest_options(@url)
  end

  def parse(raw_response)
    JSON.parse raw_response.body
  end

  def validate(data)
    data.tap { |data| validate_headers(data) }
  end

  # looks at the first row of the data to see if it has the keys we want
  def validate_headers(data)
    actual_keys = data['quotes'].first.keys

    %w[quote author season episode image].each do |expected_key|
      if actual_keys.none? { |actual_key| actual_key == expected_key }
        raise "Received unexpected data. Missing '#{expected_key}' key."
      end
    end
  end

  def default_rest_client
    RestClient::Request
  end

  def default_url
    'https://seinfeld-quotes.herokuapp.com/quotes'
  end

  def rest_options(url)
    {
      method: :get,
      url: url,
      timeout: 5
    }
  end
end
