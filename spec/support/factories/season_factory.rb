# frozen_string_literal: true

FactoryBot.define do
  factory(:season) do
    sequence(:number) { |i| i }
  end
end
