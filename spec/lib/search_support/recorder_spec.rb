# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Recorder do
  let(:user) { create(:user) }
  let(:scope) { Quote.all }

  def build_results(user, scope, match_text_params)
    search_params = build_search_params(match_text_params)
    SearchSupport::ResultsBuilder.new(
      user: user,
      scope: scope,
      search_params: search_params
    )
  end

  it 'records the search given criteria and a user' do
    Search.find_by(criteria: 'yada')&.destroy # just in case

    results_builder = build_results(user, scope, { match_text: 'yada' })

    described_class.execute(results_builder)

    search = Search.find_by(criteria: 'yada')
    expect(search).to be_a(Search)
    expect(user.searches).to include(search)
  end

  it 'records the search with an already existing criteria' do
    Search.where(criteria: 'shmoopy').first_or_create
    search = Search.find_by(criteria: 'shmoopy')

    results_builder = build_results(user, scope, { match_text: 'shmoopy' })

    described_class.execute(results_builder)

    expect(user.searches).to include(search)
  end

  it 'records the search with an already existing criteria - case insensitively' do
    Search.where(criteria: 'shmoopy').first_or_create
    search = Search.find_by(criteria: 'shmoopy')

    results_builder = build_results(user, scope, { match_text: 'Shmoopy' })

    described_class.execute(results_builder)

    expect(user.searches).to include(search)
  end

  it 'will create a new user_search entry for a search user is repeating' do
    Search.where(criteria: 'shmoopy').first_or_create
    search = Search.find_by(criteria: 'shmoopy')

    user = create(:user)
    user.searches << search

    results_builder = build_results(user, scope, { match_text: 'shmoopy' })

    expect do
      described_class.execute(results_builder)
    end.to change { UserSearch.where(user: user, search: search).count }.by(1)
  end
end
