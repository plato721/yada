# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Searcher do
  let(:user) { double(:user) }
  let(:scope) { Quote.all }
  let(:body) {'The quick brown fox jumped over the lazy dog.'}

  it 'finds exactly' do
    quote = create(:quote, body: body)

    results_builder = build_results(user, scope, match_text: body)
    described_class.execute(results_builder)

    expect(results_builder.results).to include(quote)
  end

  it 'find partial' do
    quote = create(:quote, body: body)

    results_builder = build_results(user, scope, match_text: 'fox')
    described_class.execute(results_builder)

    expect(results_builder.results).to include(quote)
  end

  it 'find case insensitively' do
    quote = create(:quote, body: body)

    results_builder = build_results(user, scope, match_text: 'juMPed')
    described_class.execute(results_builder)

    expect(results_builder.results).to include(quote)
  end

  it 'errors will be recorded' do
    bad_scope_results = SearchSupport::ResultsBuilder.new(
      user: user,
      scope: 'Not an ActiveRecordScope',
      search_params: 'Not a hash'
    )

    expect do
      described_class.execute(bad_scope_results)
    end.to_not raise_error

    expect(bad_scope_results.errors).to be_present
  end
end
