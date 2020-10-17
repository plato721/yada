require 'rails_helper'

describe Search::Filterer do
  before do
    @characters = [
      create(:character, name: "George"),
      create(:character, name: "Paul"),
      create(:character, name: "Ringo")
    ]
    quotes = [
      create(:quote, character: @characters.first),
      create(:quote, character: @characters.first),
      create(:quote, character: @characters.second),
      create(:quote, character: @characters.second),
      create(:quote, body: "something special 123", character: @characters.second),
    ]
    @quotes = Quote.includes(:character).where(id: quotes.map(&:id))
  end

  context "character filtering -" do
    it "filters for only" do
      filters = {
        "only" => {
          "characters" => ["George"]
        }
      }
      filterer = described_class.new(quotes: @quotes, filters: filters)
      quotes = filterer.filter

      expect(filterer.errors).to be_empty
      expect(quotes.distinct.pluck(:name)).to eq(["George"])
    end

    it "filters for not" do
      filters = {
        "not" => {
          "characters" => ["George"]
        }
      }
      filterer = described_class.new(quotes: @quotes, filters: filters)
      quotes = filterer.filter

      expect(filterer.errors).to be_empty
      expect(quotes.distinct.pluck(:name)).to match_array(["Paul"])
    end
  end
end
