FactoryBot.define do
  factory :character do
    sequence(:name) { |i| "Character Name #{i}" }
  end
end
