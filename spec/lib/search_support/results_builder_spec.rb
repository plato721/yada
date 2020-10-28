# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::ResultsBuilder do
  let(:user) { create :user }
  let(:scope) { Quote.all }
  let(:search_params) do
    dummy_search_params
  end
  let(:results) do
    described_class.new(
      user: user, scope: scope, search_params: search_params
    )
  end

  it 'has search params' do
    expect(results.search_params).to eq(dummy_search_params)
  end

  it 'has read only search params' do
    expect do
      results.search_params = '9er'
    end.to raise_error NoMethodError
  end

  it 'has a writeable search results' do
    quote = create(:quote, body: 'aaaaaaaa')
    expect(results.results).to eq(scope)
    expect(results.results).to include(quote)

    results.results = results.results.where(body: 'zzzzzz')

    expect(results.results).to_not include(quote)
  end

  it 'has error storage' do
    results.errors = 'this did not go well'
    expect(results.errors).to include('this did not go well')
  end
end
