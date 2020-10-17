require 'rails_helper'

describe Search::Sorter do
  let(:quotes) do
    [
      create(:quote, body: "zzz tax evasion"),
      create(:quote, body: "aaa auto"),
      create(:quote, body: "mmm middle of the road")
    ]
  end
  let(:scope){ Quote.where(id: quotes.map(&:id)) }
  let(:user){ create(:user) }

  def build_results(user, scope, sort_params)
    search_params = build_search_params(sort: sort_params)
    Search::Results.new(
      user: user,
      scope: scope,
      search_params: search_params
    )
  end

  it "sorts by quote body - ascending" do
    results = build_results(user, scope, { "body" => "asc" })

    sorter = described_class.new(results)
    sorter.execute

    expect(results.scope.pluck(:body)).to eq([
      "aaa auto",
      "mmm middle of the road",
      "zzz tax evasion"
    ])
  end

  it "sorts by quote body - descending" do
    results = build_results(user, scope, { "body" => "desc" })

    sorter = described_class.new(results)
    sorter.execute

    expect(results.scope.pluck(:body)).to eq([
      "zzz tax evasion",
      "mmm middle of the road",
      "aaa auto"
    ])
  end

  it "errors for non-body sorts" do
    results = build_results(user, scope, { "character" => "asc" })

    sorter = described_class.new(results)
    sorter.execute

    expect(results.errors).to be_present
  end

  it "errors for SQL injection sorts" do
    user = create(:user)
    results = build_results(user, scope, { "body" => "DROP TABLE USERS" })

    sorter = described_class.new(results)
    sorter.execute

    expect(results.errors).to be_present
    expect(User.find_by(id: user.id)).to be_present
  end
end
