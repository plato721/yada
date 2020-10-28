# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'search', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @demo_quotes = create_list(:quote, 5)
  end

  path '/api/v1/search' do
    post 'Search for quotes' do
      security [token_auth: []]
      parameter name: :search, in: :body, schema: {
        type: :object,
        properties: {
          search: {
            type: :object,
            properties: {
              match_text: { type: :string },
              filters: {
                type: :object,
                properties: {
                  only: {
                    type: :object,
                    properties: {
                      characters: {
                        type: :array,
                        items: { type: :string }
                      }
                    }
                  },
                  not: {
                    type: :object,
                    properties: {
                      characters: {
                        type: :array,
                        items: { type: :string }
                      }
                    }
                  }
                }
              },
              sort: {
                type: :object,
                properties: {
                  body: {
                    type: :string
                  }
                }
              }
            },
            required: ['match_text']
          }
        },
        required: ['search']
      }
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Search successful' do
        let(:token) { @user.token }
        let(:match_text) { { match_text: @demo_quotes.first.body } }
        let(:search) { { search: match_text } }
        let(:filter) { {} }
        run_test! do |_response|
          quotes = json_body['quotes']
          expect(quotes.length).to eql(1)
          expect(quotes.first['id']).to eq(@demo_quotes.first.id)
        end
      end

      response '401', 'Unauthorized' do
        let(:token) { 'won\'t be there' }
        let(:search) {}
        run_test!
      end

      response '400', 'Bad search params' do
        let(:token) { @user.token }
        let(:search) do
          { "search": {
            "match_text": 'hello',
            "filters": ['I doubt it likes this very much'],
            "sort": {
              "body": 'desc'
            }
          } }
        end
        run_test! do |response|
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
