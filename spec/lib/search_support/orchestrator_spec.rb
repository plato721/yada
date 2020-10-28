# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Orchestrator do
  let(:user) { create(:user) }
  let(:search_params) do
    ActionController::Parameters
      .new({
             'match_text' => 'yada',
             'filters' => {
               'only' => {
                 'characters' => ['Jerry']
               }
             },
             'sort' => {
               'body' => 'asc'
             }
           }).permit(:match_text, filters: {}, sort: {})
      .freeze
  end
  let(:subject) { described_class.new(user: user, search_params: search_params) }

  it 'creates the results object properly' do
    actual_results = subject.results

    expect(actual_results.search_params).to eq(search_params)
    expect(actual_results.user).to eq(user)
    expect(actual_results.scope).to eq(Quote.all.includes(:character, :season, :episode))
  end

  it 'searches with the searcher' do
    searcher = double(:searcher, execute: nil)
    allow(SearchSupport::Searcher).to receive(:new) { searcher }

    subject.search

    expect(SearchSupport::Searcher).to have_received(:new).with(subject.results)
    expect(searcher).to have_received(:execute)
  end

  it 'filters the search' do
    filterer = double(:filterer)
    allow(SearchSupport::Filterer).to receive(:new) { filterer }
    allow(filterer).to receive(:execute)

    subject.search

    expect(SearchSupport::Filterer).to have_received(:new).with(subject.results)
    expect(filterer).to have_received(:execute)
  end

  it 'sorts the search' do
    sorter = double(:sorter)
    allow(SearchSupport::Sorter).to receive(:new) { sorter }
    allow(sorter).to receive(:execute)

    subject.search

    expect(SearchSupport::Sorter).to have_received(:new).with(subject.results)
    expect(sorter).to have_received(:execute)
  end

  it 'records the search' do
    recorder = double(:recorder, execute: nil)
    allow(SearchSupport::Recorder).to receive(:new) { recorder }

    subject.search

    expect(SearchSupport::Recorder).to have_received(:new).with(subject.results)
    expect(recorder).to have_received(:execute)
  end

  context 'caching' do
    # https://makandracards.com/makandra/46189-how-to-rails-cache-for-individual-rspec-tests
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it "won't search again if cached" do
      quote = create(:quote)
      allow(SearchSupport::Searcher).to receive(:new).and_call_original

      search_params = { 'match_text' => quote.body.to_s }

      orchestrator = described_class.new(user: user, search_params: search_params)
      orchestrator.search
      expect(orchestrator.quotes).to include(quote)

      orchestrator.search
      expect(orchestrator.quotes).to include(quote)

      expect(SearchSupport::Searcher).to have_received(:new).exactly(1).times
    end

    it 'will search again if quotes updates' do
      quote = create(:quote, body: 'down by the bay')
      search_params = { 'match_text' => quote.body.to_s }
      orchestrator = described_class.new(user: user, search_params: search_params)
      orchestrator.search

      expect(orchestrator.quotes).to include(quote)

      quote_2 = create(:quote, body: 'down by the bayside')
      orchestrator.search

      expect(orchestrator.quotes).to include(quote)
      expect(orchestrator.quotes).to include(quote_2)
    end
  end
end
