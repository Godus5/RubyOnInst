FactoryBot.define do
  factory :post do
    association :user
    text { FFaker::Lorem.paragraph }
    photo_data { nil }
  end
end
