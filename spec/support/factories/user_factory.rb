# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    sequence(:email) { |i| "jane.fonda_#{i}@hotmail.com" }
    sequence(:token) { |i| (100_000_000 + i).to_s }
  end
end
