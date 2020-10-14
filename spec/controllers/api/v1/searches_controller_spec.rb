require 'rails_helper'

describe Api::V1::SearchesController do
  before(:all) do
    @user = create(:user)
    @token = @user.token
  end

  it "doesn't crash on bad params" do
    params = { missing: "everything" }
    request.headers["token"] = @token

    post :create, params: params, format: :json

    expect(response).to have_http_status(400)
  end
end
