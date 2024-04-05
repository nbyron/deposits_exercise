FactoryBot.define do
  factory :deposit do
    deposit_date { "2024-04-03" }
    amount { "9.99" }
    tradeline { nil }
  end
end
