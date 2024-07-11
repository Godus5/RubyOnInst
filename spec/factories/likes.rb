FactoryBot.define do
  factory :like do
    association :user
    association :post
    value { [1, -1].sample }
  end
end
