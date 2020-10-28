# frozen_string_literal: true

class FetchQuotesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    fetcher = SeinfeldApiClient.new
    transformer = SeinfeldEtl::Transformer
    SeinfeldEtl::Main.new(fetcher: fetcher, transformer: transformer).execute
  end
end
