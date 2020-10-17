require 'rails_helper'

describe Search::Sorter do
  before do
    quotes = [
      create(:quote, body: "zzz tax evasion"),
      create(:quote, body: "aaa auto"),
      create(:quote, body: "mmm middle of the road")
    ]
    @quotes = Quote.where(id: quotes.map(&:id))
  end

  it "sorts by quote body - ascending" do
    sort_params = { "body" => "asc" }

    sorter = described_class.new(quotes: @quotes, sort_params: sort_params)
    quotes = sorter.sort

    expect(quotes.pluck(:body)).to eq([
      "aaa auto",
      "mmm middle of the road",
      "zzz tax evasion"
    ])
  end

  it "sorts by quote body - descending" do
    sort_params = { "body" => "desc" }

    sorter = described_class.new(quotes: @quotes, sort_params: sort_params)
    quotes = sorter.sort

    expect(quotes.pluck(:body)).to eq([
      "zzz tax evasion",
      "mmm middle of the road",
      "aaa auto"
    ])
  end

  it "errors for non-body sorts" do
    sort_params = { "character" => "asc" }

    sorter = described_class.new(quotes: @quotes, sort_params: sort_params)
    quotes = sorter.sort

    expect(sorter.errors).to be_present
  end

  it "errors for SQL injection sorts" do
    user = create(:user)
    sort_params = { "body" => "DROP TABLE USERS" }

    sorter = described_class.new(quotes: @quotes, sort_params: sort_params)
    quotes = sorter.sort

    expect(sorter.errors).to be_present
    expect(User.find_by(id: user.id)).to be_present
  end
end
