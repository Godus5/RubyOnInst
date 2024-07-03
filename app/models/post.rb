class Post < ApplicationRecord
  include PhotoUploader::Attachment(:photo) # adds an `photo` virtual attribute

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :text, presence: true

  def total_likes
    likes.sum(:value)
  end
end
