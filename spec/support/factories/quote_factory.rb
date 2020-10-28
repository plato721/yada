# frozen_string_literal: true

FactoryBot.define do
  sequence(:quote_body) do |i|
    'Defining this up here to give us room to make a sentence of some sort. '\
    "A unique one, of course. #{i}"
  end

  factory(:quote) do
    sequence(:body) { generate(:quote_body) }
    character
    season
    episode
  end
end
