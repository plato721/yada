# frozen_string_literal: true

require 'rails_helper'

describe SeinfeldApiClient do
  before :all do
    VCR.turn_on!
    WebMock.enable!
    VCR.use_cassette('seinfeld_api_index') do
      @data = described_class.new.execute
    end
  end

  after :all do
    VCR.turn_off!
    WebMock.disable!
  end

  it 'has quotes' do
    expect(@data['quotes']).to be_present
  end

  it 'has the expected keys in a single quote' do
    quote = @data['quotes'].first

    expect(quote.keys).to match_array(%w[quote author season episode image])
  end

  context 'sad path - network trouble' do
    it 'raises an error' do
      quote_getter = described_class.new(url: 'somehting.not.real.asdf.com')
      VCR.use_cassette('seinfeld_bad_request') do
        expect { quote_getter.execute }.to raise_error SocketError
      end
    end
  end

  context ' sad path - good response with bad data' do
    it 'flags an error if keys are missing' do
      quote_getter = described_class.new
      bad_data = { 'quotes' => [{ 'bad' => 'data' }] }

      expect do
        quote_getter.send(:validate, bad_data)
      end.to raise_error RuntimeError
    end
  end
end
