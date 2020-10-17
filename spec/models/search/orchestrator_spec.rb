require 'rails_helper'

describe Search::Orchestrator do
  let(:user){ create(:user) }
  let(:search_params) do
    ActionController::Parameters
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
  let(:subject){ described_class.new(user: user, search_params: search_params)}

  it "creates the results object properly" do
    actual_results = subject.results

    expect(actual_results.search_params).to eq(search_params)
    expect(actual_results.user).to eq(user)
    expect(actual_results.scope).to eq(Quote.all.includes(:character, :season, :episode))
  end

  it "searches with the searcher" do
    searcher = double(:searcher, execute: nil)
    allow(Search::Searcher).to receive(:new){ searcher }

    subject.search

    expect(Search::Searcher).to have_received(:new).with(subject.results)
    expect(searcher).to have_received(:execute)
  end

  it "filters the search" do
    filterer = double(:filterer)
    allow(Search::Filterer).to receive(:new){ filterer }
    allow(filterer).to receive(:execute)

    subject.search

    expect(Search::Filterer).to have_received(:new).with(subject.results)
    expect(filterer).to have_received(:execute)
  end

  it "sorts the search" do
    sorter = double(:sorter)
    allow(Search::Sorter).to receive(:new){ sorter }
    allow(sorter).to receive(:execute)

    subject.search

    expect(Search::Sorter).to have_received(:new).with(subject.results)
    expect(sorter).to have_received(:execute)
  end

  it "records the search" do
    recorder = double(:recorder, execute: nil)
    allow(Search::Recorder).to receive(:new){ recorder }

    subject.search

    expect(Search::Recorder).to have_received(:new).with(subject.results)
    expect(recorder).to have_received(:execute)
  end
end
