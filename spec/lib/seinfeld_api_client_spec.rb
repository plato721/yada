# frozen_string_literal: true

require 'rails_helper'

describe SeinfeldApiClient do
  before :all do
    @quote_getter = described_class.new
    VCR.turn_on!
    WebMock.enable!
    VCR.use_cassette('seinfeld_api_index') do
      @quote_getter.execute
    end
  end

  after :all do
    VCR.turn_off!
    WebMock.disable!
  end

  it 'has quotes' do
    data = @quote_getter.data
    expect(data['quotes']).to be_present
  end

  it 'has the expected keys in a single quote' do
    quote = @quote_getter.data['quotes'].first

    expect(quote.keys).to match_array(%w[quote author season episode image])
  end

  context 'sad path - network trouble' do
    before :all do
      options = { url: 'somehting.not.real.asdf.com' }
      @quote_getter = described_class.new(options)
      @quote_getter.execute
    end

    it 'has no data' do
      expect(@quote_getter.data).to be_nil
    end

    it 'has an error set' do
      expect(@quote_getter.error_message).to be_present
    end
  end

  context ' sad path - good response with bad data' do
    it 'flags an error if keys are missing' do
      bad_data = { 'quotes' => [{ 'bad' => 'data' }] }
      allow(@quote_getter).to receive(:data) { bad_data }

      VCR.use_cassette('seinfeld_api_index') do
        @quote_getter.execute
      end

      expect(@quote_getter.error_message).to match(/unexpected data/)
    end
  end
end
