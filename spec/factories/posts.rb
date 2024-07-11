FactoryBot.define do
  factory :post do
    association :user
    text { FFaker::Lorem.paragraph }
    photo { nil }
  end
end
