require 'swagger_helper'

RSpec.describe 'search', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @demo_quotes = create_list(:quote, 5)
  end

  path '/api/v1/search' do
    post 'Search for quotes' do
      parameter name: :token, in: :header, type: :string
      parameter name: :search, in: :body, schema: {
        type: :object,
        properties: {
          search: { 
            type: :object,
            properties: {
              match_text: { type: :string }
            },
            required: [ 'match_text' ]
          }
        },
        required: [ 'search' ]
      }
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Search successful' do
        let(:token) { @user.token }
        let(:match_text) { { match_text: @demo_quotes.first.body } }
        let(:search) { { search: match_text } }
        run_test! do |response|
          quotes = json_body["quotes"]
          expect(quotes.length).to eql(1)
          expect(quotes.first["id"]).to eq(@demo_quotes.first.id)
        end
      end

      response '401', 'Unauthorized' do
        let(:token) { 'won\'t be there' }
        let(:search){}
        run_test!
      end
    end
  end
end
