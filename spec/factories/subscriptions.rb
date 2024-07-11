FactoryBot.define do
  factory :subscription do
    association :user
    association :follower, factory: :user
  end
end
