class User < ApplicationRecord
  # Subscriber associations
  has_many :subscriptions, foreign_key: :user_id, dependent: :destroy
  has_many :followers, through: :subscriptions, source: :follower

  # Subscriptions associations
  has_many :reverse_subscriptions, class_name: "Subscription", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :reverse_subscriptions, source: :user

  belongs_to :account
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
end
