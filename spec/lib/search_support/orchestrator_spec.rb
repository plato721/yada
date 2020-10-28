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

  it 'searches with the searcher' do
    allow(SearchSupport::Searcher).to receive(:execute)

    subject.search

    expect(SearchSupport::Searcher).to have_received(:execute)
  end

  it 'filters the search' do
    allow(SearchSupport::Filterer).to receive(:execute)

    subject.search

    expect(SearchSupport::Filterer).to have_received(:execute)
  end

  it 'sorts the search' do
    allow(SearchSupport::Sorter).to receive(:execute)

    subject.search

    expect(SearchSupport::Sorter).to have_received(:execute)
  end

  it 'records the search' do
    allow(SearchSupport::Recorder).to receive(:execute)

    subject.search

    expect(SearchSupport::Recorder).to have_received(:execute)
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
      allow(SearchSupport::Searcher).to receive(:execute).and_call_original

      search_params = { 'match_text' => quote.body.to_s }

      orchestrator = described_class.new(user: user, search_params: search_params)
      results = orchestrator.search
      expect(results).to include(quote)

      updated_results = orchestrator.search
      expect(updated_results).to include(quote)

      expect(SearchSupport::Searcher).to have_received(:execute).exactly(1).times
    end

    it 'will search again if quotes updates' do
      quote = create(:quote, body: 'down by the bay')
      search_params = { 'match_text' => quote.body.to_s }
      orchestrator = described_class.new(user: user, search_params: search_params)
      results = orchestrator.search

      expect(results).to include(quote)

      quote_2 = create(:quote, body: 'down by the bayside')
      updated_results = orchestrator.search

      expect(updated_results).to include(quote)
      expect(updated_results).to include(quote_2)
    end
  end
end
