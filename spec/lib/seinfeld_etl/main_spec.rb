require 'rails_helper'

describe SeinfeldEtl::Main do
  let(:sample_data) do
    { "quotes" => [{"quote"=>"Elaine, he's a male bimbo. He's a mimbo!",
      "author"=>"Jerry",
      "season"=>"5",
      "episode"=>"12",
      "image"=>""},
     {"quote"=>"Hello, 911? How are ya?", "author"=>"Jerry", "season"=>"4", "episode"=>"1/2", "image"=>""},
     {"quote"=>"You should do it like a band-aid -- one motion, RIGHT OFF!",
      "author"=>"Jerry",
      "season"=>"2",
      "episode"=>"1",
      "image"=>"./Images/6-1.png"},
     {"quote"=>"I want to be the one person who doesn't die with dignity.",
      "author"=>"George",
      "season"=>"4",
      "episode"=>"23",
      "image"=>""},
     {"quote"=>"I would give up red meat just to get a glimpse of you in a bra.",
      "author"=>"George",
      "season"=>"6",
      "episode"=>"9",
      "image"=>""}]
    }
  end

  before do
    ensure_spec_readiness
    fetcher = SeinfeldApiClient.new
    allow(fetcher).to receive(:execute){}
    allow(fetcher).to receive(:data){ sample_data }
    @main = described_class.new(fetcher: fetcher)
    @main.execute
  end

  def ensure_spec_readiness
    [Quote, Character, Season, Episode].each do |klass|
      raise "Database polluted" unless klass.count.zero?
    end
  end

  it "creates quotes and supporting objects idempotently" do
    expect(Quote.count).to eql(sample_data["quotes"].length)

    @main.execute
    expect(Quote.count).to eql(sample_data["quotes"].length)
  end

  it "creates a quote accurately" do
    quote = Quote.find_by(body: "I would give up red meat just to get a glimpse of you in a bra.")
    expect(quote.season.number).to eq(6)
    expect(quote.episode.number).to eq(9)
    expect(quote.character.name).to eq("George")
  end

  it "creates the characters properly" do
    result = Character.pluck(:name)
    expect(result).to match_array(["George", "Jerry"])
  end
end
