# frozen_string_literal: true

require 'rails_helper'

describe FetchQuotesJob do
  it 'calls the seinfeld etl main' do
    fetcher = SeinfeldEtl::Main.new
    allow(fetcher).to receive(:execute)
    allow(SeinfeldEtl::Main).to receive(:new) { fetcher }

    described_class.new.perform_now

    expect(fetcher).to have_received(:execute)
  end
end
