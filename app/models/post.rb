class Post < ApplicationRecord
  include PhotoUploader::Attachment(:photo) # adds an `photo` virtual attribute

  belongs_to :user

  validates :text, presence: true
end
