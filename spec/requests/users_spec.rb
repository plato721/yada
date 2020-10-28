# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/api/v1/users' do
    post 'Create an api token' do
      description <<~EOF
        Provide an email address to create a user token. You
        may choose your own token if you so desire, but keep
        in mind this is a toy app and everything is passed
        and stored in clear text. Both email and token must
        be unique within the application.
      EOF
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              token: { type: :string }
            },
            required: ['email']
          },
          required: ['user']
        }
      }

      response '201', 'User/Token Created' do
        let(:user) { { user: { email: 'abe.lincoln@hotmail.com' } } }
        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body.keys).to match_array(%w[email token])
          expect(body['email']).to eql('abe.lincoln@hotmail.com')
          expect(body['token']).to_not be_blank
        end
      end

      response '422', 'Blank email' do
        let(:user) { { user: { email: '' } } }
        run_test!
      end

      response '400', 'Bad params' do
        let(:user) {}
        run_test!
      end
    end
  end
end
