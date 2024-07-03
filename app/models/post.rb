class Post < ApplicationRecord
  include PhotoUploader::Attachment(:photo) # adds an `photo` virtual attribute

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :text, presence: true
end
