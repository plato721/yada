# frozen_string_literal: true

require 'rails_helper'

describe SeinfeldEtl::Main do
  let(:sample_data) do
    { 'quotes' => [{ 'quote' => "Elaine, he's a male bimbo. He's a mimbo!",
                     'author' => 'Jerry',
                     'season' => '5',
                     'episode' => '12',
                     'image' => '' },
                   { 'quote' => 'Hello, 911? How are ya?', 'author' => 'Jerry', 'season' => '4', 'episode' => '1/2',
                     'image' => '' },
                   { 'quote' => 'You should do it like a band-aid -- one motion, RIGHT OFF!',
                     'author' => 'Jerry',
                     'season' => '2',
                     'episode' => '1',
                     'image' => './Images/6-1.png' },
                   { 'quote' => "I want to be the one person who doesn't die with dignity.",
                     'author' => 'George',
                     'season' => '4',
                     'episode' => '23',
                     'image' => '' },
                   { 'quote' => 'I would give up red meat just to get a glimpse of you in a bra.',
                     'author' => 'George',
                     'season' => '6',
                     'episode' => '9',
                     'image' => '' }] }
  end
  let(:transformer) { SeinfeldEtl::Transformer }
  let(:fetcher) { SeinfeldApiClient.new }

  before do
    allow(fetcher).to receive(:execute) { sample_data }
    @main = described_class.new(fetcher: fetcher, transformer: transformer)
  end

  it 'creates quotes and supporting objects idempotently' do
    expect  do
      @main.execute
    end.to change { Quote.count }.by(sample_data['quotes'].length)

    expect do
      @main.execute
    end.to_not change { Quote.count }
  end

  it 'creates a quote accurately' do
    @main.execute

    quote = Quote.find_by(body: 'I would give up red meat just to get a glimpse of you in a bra.')
    expect(quote.season.number).to eq(6)
    expect(quote.episode.number).to eq(9)
    expect(quote.character.name).to eq('George')
  end

  it 'creates the characters properly' do
    @main.execute

    result = Character.pluck(:name)
    expect(result).to match_array(%w[George Jerry])
  end

  context 'fetch failure' do
    before do
      fetcher = double(:fetcher,
                       execute: nil,
                       error_message: 'Something terrible happened.')
      @main = described_class.new(fetcher: fetcher, transformer: transformer)
    end

    it 'execution is false' do
      expect(@main.execute).to be_falsey
    end

    it 'logs errors' do
      allow(Rails.logger).to receive(:error)
      @main.execute
      expect(Rails.logger).to have_received(:error)
    end
  end
end
