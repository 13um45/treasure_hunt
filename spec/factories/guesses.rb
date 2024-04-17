FactoryBot.define do
  factory :guess do
    player { nil }
    treasure { nil }
    lat { "9.99" }
    long { "9.99" }
    distance_from_treasure { 1 }
    winner { false }
  end
end
