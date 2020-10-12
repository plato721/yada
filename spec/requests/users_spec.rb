require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/api/v1/users' do
    post 'Creates an api token' do
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          token: { type: :string }
        },
        required: [ 'email' ]
      }

      response '201', 'user created' do
        let(:user) { { email: 'abe.lincoln@hotmail.com' } }
        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body.keys).to match_array(["email", "token"])
          expect(body["email"]).to eql("abe.lincoln@hotmail.com")
          expect(body["token"]).to_not be_blank
        end
      end

      response '422', 'blank email' do
        let(:user) { { email: '' } }
        run_test!
      end
    end
  end
end
