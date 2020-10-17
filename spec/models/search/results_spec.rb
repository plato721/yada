require 'rails_helper'

describe Search::Results do
  let(:user){ create :user }
  let(:scope){ Quote.all }
  let(:search_params){
    dummy_search_params
  }
  let(:results) do
    described_class.new(
    user: user, scope: scope, search_params: search_params
    )
  end

  it "has search params" do
    expect(results.search_params).to eq(dummy_search_params)
  end

  it "has read only search params" do
    expect{
      results.search_params = "9er"
    }.to raise_error NoMethodError
  end

  it "has a writeable search scope" do
    quote = create(:quote, body: "aaaaaaaa")
    expect(results.scope).to eq(scope)
    expect(results.scope).to include(quote)

    results.scope = results.scope.where(body: "zzzzzz")

    expect(results.scope).to_not include(quote)
  end

  it "has error storage" do
    results.add_error "this did not go well"
    expect(results.errors).to include("this did not go well")
  end
end
