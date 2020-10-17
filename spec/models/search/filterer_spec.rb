require 'rails_helper'

describe Search::Filterer do
  let(:user){ create(:user) }
  let(:characters) do
    [
      create(:character, name: "George"),
      create(:character, name: "Paul"),
      create(:character, name: "Ringo")
    ]
  end
  let(:quotes) do
    [
      create(:quote, character: characters.first),
      create(:quote, character: characters.first),
      create(:quote, character: characters.second),
      create(:quote, character: characters.second),
      create(:quote, body: "something special 123", character: characters.second)
    ]
  end
  let(:scope){ Quote.includes(:character).where(id: quotes.map(&:id)) }

  def build_results(user, scope, filter_params)
    search_params = build_search_params(filter_params)
    Search::Results.new(
      user: user,
      scope: scope,
      search_params: search_params
    )
  end

  context "character filtering -" do
    it "filters for only" do
      filters =  {
        "only" => {
          "characters" => ["George"]
        }
      }
      results = build_results(user, scope, filters: filters)

      filterer = described_class.new(results)
      filterer.execute

      expect(results.errors).to be_empty
      expect(results.scope.distinct.pluck(:name)).to eq(["George"])
    end

    it "filters for not" do
      filters = {
        "not" => {
          "characters" => ["George"]
        }
      }
      results = build_results(user, scope, filters: filters)

      filterer = described_class.new(results)
      filterer.execute

      expect(results.errors).to be_empty
      expect(results.scope.distinct.pluck(:name)).to match_array(["Paul"])
    end
  end
end
