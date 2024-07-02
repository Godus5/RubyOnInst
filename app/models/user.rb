class User < ApplicationRecord
  belongs_to :account
  has_many :posts

  validates :first_name, presence: true
  validates :last_name, presence: true
end
