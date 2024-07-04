class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :value, inclusion: {in: [-1, 1]}
  validates :user_id, uniqueness: {scope: :post_id, message: "Can like/dislike a post only once"}
end
