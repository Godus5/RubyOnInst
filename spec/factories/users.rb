FactoryBot.define do
  factory :user do
    association :account
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    nickname { FFaker::Internet.user_name }
    bio { FFaker::Lorem.paragraph }
  end
end
