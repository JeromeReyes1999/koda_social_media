class Post < ApplicationRecord
  validates :text, :audience, presence: true
  enum audience: [:everyone, :friends_only, :only_me]
  belongs_to :user
  has_many :comments, dependent: :destroy

  mount_uploader :image, ImageUploader

  def location
    [city, district ,province].reject(&:blank?).join(", ")
  end
end
