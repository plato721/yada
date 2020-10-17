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

    params = {
      search: {
        match_text: "yada",
        filters: {
          not: ["Elaine"]
        },
        sort: {
          body: "asc"
        }
      }
    }

    post :create, params: params, format: :json

    expect(response).to have_http_status(:ok)
    expect(Search::Orchestrator).to have_received(:new).with(
      search_params: dummy_search_params,
      user: dummy_user)
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

  context "basic integration for sanity" do
    it "searches with side effects" do
      Search.find_by(criteria: "anything")&.destroy
      Quote.where('body LIKE ?', "anything").destroy_all

      create(:quote, body: "Anything goes")
      user = create(:user)
      sign_in(user)

      params = { search: { match_text: "anything" }}

      post :create, params: params, format: :json

      expect(response).to have_http_status(:ok)
      expect(json_body["quotes"].length).to eq(1)

      search = Search.find_by(criteria: "anything")
      expect(search).to be_present

      search_instance = UserSearch.find_by(user: user, search: search)
      expect(search_instance).to be_present

      expect(user.searches).to include(search)
    end
  end
end
