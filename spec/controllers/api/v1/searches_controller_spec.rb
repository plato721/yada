require 'rails_helper'

describe Api::V1::SearchesController do
  before do
    sign_in(dummy_user)
  end

  it "doesn't crash on bad params" do
    params = { missing: "everything" }

    post :create, params: params, format: :json

    expect(response).to have_http_status(400)
  end

  it "calls the searcher" do
    searcher  = double(:searcher,
      search: nil,
      errors: [],
      quotes: Quote.none
    )
    allow(Search::Orchestrator).to receive(:new){ searcher }

    params = { search: { match_text: "yada" }}

    post :create, params: params, format: :json

    expect(response).to have_http_status(:ok)
    expect(Search::Orchestrator).to have_received(:new).with(
      ActionController::Parameters.new({match_text: "yada"})
      .permit(:match_text))
    expect(searcher).to have_received(:search)
  end

  it "responds with bad request on searcher errors" do
    searcher  = double(:searcher,
      search: nil,
      errors: ["something went wrong"],
      quotes: Quote.none
    )
    allow(Search::Orchestrator).to receive(:new){ searcher }

    params = { search: { match_text: "yada" }}

    post :create, params: params, format: :json

    expect(response).to have_http_status(:bad_request)
    expect(json_body["error"]).to be_present
  end
end
