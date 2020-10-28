# frozen_string_literal: true

require 'rails_helper'

describe UserSearch do
  it 'takes a user and a search' do
    user = create(:user)
    search = create(:search)

    user_search = UserSearch.create(user: user, search: search)

    expect(user_search).to be_persisted
    expect(user_search.user).to eq(user)
    expect(user_search.search).to eq(search)
  end
end
