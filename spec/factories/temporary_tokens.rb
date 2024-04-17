FactoryBot.define do
  factory :temporary_token do
    player { nil }
    hashed_token { "MyString" }
    expiry { "2024-04-16 17:53:49" }
    enabled { false }
  end
end
