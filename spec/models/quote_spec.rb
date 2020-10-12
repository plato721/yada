require 'rails_helper'

describe Quote do
  it { is_expected.to belong_to(:season) }
  it { is_expected.to belong_to(:character) }
  it { is_expected.to belong_to(:episode) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_uniqueness_of(:body) }

  it "has a factory" do
    expect{
      @quotes = create_list(:quote, 2)
    }.to change{ Quote.count }.by(2)

    quote = @quotes.first

    expect(quote.body).to be_a String
    expect(quote.body).to_not be_empty

    expect(quote.character).to be_a(Character)
    expect(quote.episode).to be_a(Episode)
    expect(quote.season).to be_a(Season)
  end
end
