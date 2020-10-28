# frozen_string_literal: true

require 'rails_helper'

describe SearchSupport::Sorter do
  let(:quotes) do
    [
      create(:quote, body: 'zzz tax evasion'),
      create(:quote, body: 'aaa auto'),
      create(:quote, body: 'mmm middle of the road')
    ]
  end
  let(:scope) { Quote.where(id: quotes.map(&:id)) }
  let(:user) { create(:user) }

  it 'sorts by quote body - ascending' do
    results_builder = build_results(user, scope, sort: { 'body' => 'asc' })

    described_class.execute(results_builder)

    expect(results_builder.results.pluck(:body)).to eq([
                                                         'aaa auto',
                                                         'mmm middle of the road',
                                                         'zzz tax evasion'
                                                       ])
  end

  it 'sorts by quote body - descending' do
    results_builder = build_results(user, scope, sort: { 'body' => 'desc' })

    described_class.execute(results_builder)

    expect(results_builder.results.pluck(:body)).to eq([
                                                         'zzz tax evasion',
                                                         'mmm middle of the road',
                                                         'aaa auto'
                                                       ])
  end

  it 'errors for non-body sorts' do
    results_builder = build_results(user, scope, sort: { 'character' => 'asc' })

    described_class.execute(results_builder)

    expect(results_builder.errors).to be_present
  end

  it 'errors for SQL injection sorts' do
    user = create(:user)
    results_builder = build_results(user, scope, sort: { 'body' => 'DROP TABLE USERS' })

    described_class.execute(results_builder)

    expect(results_builder.errors).to be_present
    expect(User.find_by(id: user.id)).to be_present
  end
end
