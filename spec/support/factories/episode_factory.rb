FactoryBot.define do
  factory(:episode) do
    sequence(:number){ |i| i }
  end
end
