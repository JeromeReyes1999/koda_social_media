class Post < ApplicationRecord
  validates :text, presence: true
  enum audience: [:everyone, :friends_only, :only_me]
  belongs_to :user

  mount_uploader :image, ImageUploader
end
