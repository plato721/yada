require 'rails_helper'

describe Search::Orchestrator do
  before do
    @user = create(:user)
    @valid_params = ActionController::Parameters
      .new({
        "match_text" => "yada",
        "filters" => {
          "only" => {
            "characters" => ["Jerry"]
           }
         },
         "sort" => {
            "body" => "asc"
         }
       }).permit(:match_text, filters: {}, sort: {})
         .freeze
  end

  it "records the search" do
    recorder = Search::Recorder.new
    allow(recorder).to receive(:record)

    orchestrator = described_class.new(
      user: @user,
      search_params: @valid_params,
      recorder: recorder)

    orchestrator.search

    expect(recorder).to have_received(:record).with(@user, "yada")
  end

  it "filters the search" do
    filterer = Search::Filterer.new(quotes: Quote.all,
      filters: @valid_params["filters"])
    allow(Search::Filterer).to receive(:new){ filterer }
    allow(filterer).to receive(:filter)

    orchestrator = described_class.new(
      user: @user,
      search_params: @valid_params)
    orchestrator.search

    expect(filterer).to have_received(:filter)
  end

  it "sorts the search" do
    sorter = Search::Sorter.new(quotes: Quote.all,
      sort_params: @valid_params["sort"])
    allow(Search::Sorter).to receive(:new){ sorter }
    allow(sorter).to receive(:sort)

    orchestrator = described_class.new(
      user: @user,
      search_params: @valid_params)
    orchestrator.search

    expect(sorter).to have_received(:sort)
  end
end
