# frozen_string_literal: true

class FetchQuotesJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    SeinfeldEtl::Main.new.execute
  end
end
