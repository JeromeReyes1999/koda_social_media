class Group < ApplicationRecord
  validates :name, :description, :banner, :owner, :can_invite, :privacy, presence: true
  belongs_to :owner, class_name: "User"
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :posts, dependent: :destroy
  enum privacy: [:unrestricted, :restricted]
  after_create :create_user_group_record_for_owner
  mount_uploader :banner, ImageUploader

  def create_user_group_record_for_owner
    owner_user_group = UserGroup.new(user: owner, group: self, roles: :admin, state: :accepted)
    owner_user_group.save!
  end

  def member?(user)
    user_groups.accepted.find_by(user: user).present?
  end
end
