require 'rails_helper'

describe "Getting an API Token", type: :request do
  it "creates a user" do
    params = { user: { email: "abe.lincoln@hotmail.com" } }

    post "/api/v1/users", params: params

    expect(response).to have_http_status(:created)

    body = JSON.parse(response.body)

    expect(body.keys).to match_array(["email", "token"])
    expect(body["email"]).to eql("abe.lincoln@hotmail.com")
    expect(body["token"]).to_not be_blank
  end
end
