# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Searcher do
  let(:user) { double(:user) }
  let(:scope) { Quote.all }
  let(:body) { 'The quick brown fox jumped over the lazy dog.' }

  def build_results(user, scope, search_text)
    search_params = build_search_params(match_text: search_text)
    SearchSupport::Results.new(
      user: user,
      scope: scope,
      search_params: search_params
    )
  end

  it 'finds exactly' do
    quote = create(:quote, body: body)

    results = build_results(user, scope, body)
    described_class.new(results).execute

    expect(results.scope).to include(quote)
  end

  it 'find partial' do
    quote = create(:quote, body: body)

    results = build_results(user, scope, 'fox')
    described_class.new(results).execute

    expect(results.scope).to include(quote)
  end

  it 'find case insensitively' do
    quote = create(:quote, body: body)

    results = build_results(user, scope, 'juMPed')
    described_class.new(results).execute

    expect(results.scope).to include(quote)
  end

  it 'errors will be recorded' do
    bad_scope_results = SearchSupport::Results.new(
      user: user,
      scope: 'Not an ActiveRecordScope',
      search_params: 'Not a hash'
    )

    expect do
      described_class.new(bad_scope_results).execute
    end.to_not raise_error

    expect(bad_scope_results.errors).to be_present
  end
end
