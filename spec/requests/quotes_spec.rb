require 'swagger_helper'

RSpec.describe 'quotes', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @demo_quotes = create_list(:quote, 5)
  end

  path '/api/v1/quotes' do
    get 'Gets the quotes' do
      parameter name: :token, in: :header, type: :string
      produces 'application/json'
      consumes 'application/json'
      response '200', 'quotes retrieved' do
        let(:token) { @user.token }
        run_test! do |response|
          quotes = json_body["quotes"]

          # ensure demo quotes are all present in the list
          @demo_quotes.each do |quote|
            expect(quotes.any? do |quote_response|
              quote_response["id"] == quote.id
            end).to be_truthy
          end

          # check all the attributes of a single quote
          received_quote = quotes.find do |quote|
            quote["id"] == @demo_quotes.first.id
          end
          remote_quote = Quote.find(@demo_quotes.first.id)

          expect(received_quote.keys).to match_array(
            ["id", "body", "season", "character", "episode"]
          )

          # Quote Body
          expect(received_quote["body"]).to eql(remote_quote.body)

          # Season
          expect(received_quote["season"].keys).to match_array(
            ["number", "id"]
          )
          expect(received_quote["season"]["number"]).to eql(remote_quote.season.number)
          expect(received_quote["season"]["id"]).to eql(remote_quote.season.id)

          # Episode
          expect(received_quote["episode"].keys).to match_array(
            ["number", "id"]
          )
          expect(received_quote["episode"]["number"]).to eql(remote_quote.episode.number)
          expect(received_quote["episode"]["id"]).to eql(remote_quote.episode.id)

          # Character
          expect(received_quote["character"].keys).to match_array(
            ["name", "id"]
          )
          expect(received_quote["character"]["name"]).to eql(remote_quote.character.name)
          expect(received_quote["character"]["id"]).to eql(remote_quote.character.id)
        end
      end
    end
  end
end
