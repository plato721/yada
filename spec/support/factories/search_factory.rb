FactoryBot.define do
  factory :search do
    sequence(:criteria){ |i| "words to look for #{i}"}
  end
end
