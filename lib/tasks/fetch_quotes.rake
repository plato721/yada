namespace :yada do
  desc "Fetch and store quotes from the Seinfeld API"
  task fetch_quotes: :environment do
    FetchQuotesJob.perform_now
  end

  desc "Drop, recreate, and fetch external data to database"
  task clean_slate: [:environment, 'db:reset', :fetch_quotes]

  desc "Create and populate database"
  task app_setup: [:environment, 'db:setup', :fetch_quotes]
end
