FactoryBot.define do
  factory :long_lived_token do
    player { nil }
    hashed_token { "MyString" }
    expiry { "2024-04-16 17:54:05" }
    enabled { false }
  end
end
