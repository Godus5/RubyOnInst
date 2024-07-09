FactoryBot.define do
  factory :comment do
    association :user
    association :post
    text { FFaker::Lorem.sentence }
  end
end
