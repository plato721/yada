# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'quotes', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @demo_quotes = create_list(:quote, 5)
  end

  path '/api/v1/quotes' do
    get 'Retrieves all quotes' do
      security [token_auth: []]
      produces 'application/json'

      response '200', 'quotes retrieved' do
        let(:token) { @user.token }
        run_test! do |_response|
          quotes = json_body['quotes']

          # ensure demo quotes are all present in the list
          @demo_quotes.each do |quote|
            expect(quotes.any? do |quote_response|
              quote_response['id'] == quote.id
            end).to be_truthy
          end

          # check all the attributes of a single quote
          received_quote = quotes.find do |quote|
            quote['id'] == @demo_quotes.first.id
          end
          remote_quote = Quote.find(@demo_quotes.first.id)

          check_quote(received_quote, remote_quote)
        end
      end

      response '401', 'unauthorized' do
        let(:token) { 'won\'t be there' }
        run_test!
      end
    end
  end

  path '/api/v1/quotes/{id}' do
    get 'Gets a single quote' do
      security [token_auth: []]
      parameter name: :id, in: :path, type: :integer
      produces 'application/json'

      response '200', 'quote retrieved' do
        let(:token) { @user.token }
        let(:id) { @demo_quotes.first.id }
        run_test! do |_response|
          received_quote = json_body['quote']
          remote_quote = Quote.find(@demo_quotes.first.id)

          check_quote(received_quote, remote_quote)
        end
      end

      response '404', 'quote not found' do
        let(:token) { @user.token }
        let(:id) { Quote.maximum(:id) + 1 }
        run_test!
      end
    end
  end

  def check_quote(received, expected)
    expect(received.keys).to match_array(
      %w[id body season character episode]
    )

    # Quote Body
    expect(received['body']).to eql(expected.body)

    # Season
    expect(received['season'].keys).to match_array(
      %w[number id]
    )
    expect(received['season']['number']).to eql(expected.season.number)
    expect(received['season']['id']).to eql(expected.season.id)

    # Episode
    expect(received['episode'].keys).to match_array(
      %w[number id]
    )
    expect(received['episode']['number']).to eql(expected.episode.number)
    expect(received['episode']['id']).to eql(expected.episode.id)

    # Character
    expect(received['character'].keys).to match_array(
      %w[name id]
    )
    expect(received['character']['name']).to eql(expected.character.name)
    expect(received['character']['id']).to eql(expected.character.id)
  end
end
