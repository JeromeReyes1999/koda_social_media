class Post < ApplicationRecord
  validates :text, presence: true
  enum audience: [:everyone, :friends_only, :only_me]
  belongs_to :user
  has_many :comments

  mount_uploader :image, ImageUploader
end
