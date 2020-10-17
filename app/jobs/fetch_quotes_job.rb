class FetchQuotesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SeinfeldEtl::Main.new.execute
  end
end
