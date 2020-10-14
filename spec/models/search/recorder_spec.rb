require 'rails_helper'

describe Search::Recorder do
  it "records the search given criteria and a user" do
    criteria = "yada"
    Search.find_by(criteria: criteria)&.destroy # just in case

    user = create(:user)
    recorder = described_class.new

    recorder.record(user, criteria)

    search = Search.find_by(criteria: criteria)
    expect(search).to be_a(Search)
    expect(user.searches).to include(search)
  end

  it "records the search with an already existing criteria" do
    criteria = "shmoopy"
    Search.where(criteria: criteria).first_or_create
    search = Search.find_by(criteria: criteria)

    user = create(:user)
    recorder = described_class.new

    recorder.record(user, criteria)

    expect(user.searches).to include(search)
  end

  it "will create a new user_search entry for a search user is repeating" do
    criteria = "shmoopy"
    Search.where(criteria: criteria).first_or_create
    search = Search.find_by(criteria: criteria)

    user = create(:user)
    user.searches << search
    recorder = described_class.new

    expect{
      recorder.record(user, criteria)
    }.to change{ UserSearch.where(user: user, search: search).count }.by(1)
  end
end
