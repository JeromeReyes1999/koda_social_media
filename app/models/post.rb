class Post < ApplicationRecord

  validates :text, presence: true
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :group, optional: true
  belongs_to :admin, optional: true
  belongs_to :report, optional: true

  enum audience: [:everyone, :friends_only, :only_me]

  after_create :publish_managers_post

  mount_uploader :image, ImageUploader

  def location
    [city, district, province].reject(&:blank?).join(", ")
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :published, :removed

    event :publish do
      transitions from: :pending, to: :published
    end

    event :remove do
      transitions from: [:published, :pending], to: :removed
    end
  end

  def publish_managers_post
    return if group.nil?
    unless user.user_groups.find_by(group: group).normal?
      publish!
    end
  end

end
