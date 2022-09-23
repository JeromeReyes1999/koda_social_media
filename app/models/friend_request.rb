class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: "User"

  validate :friend_request_unique?, on: :create
  validate :reject_self_request, on: :create

  enum state: [:pending, :accepted]

  def friend_request_unique?
    if user.associated_users.include? receiver
      errors.add(:base, "You and #{receiver.email} are either already friend or has a pending request")
    end
  end

  def reject_self_request
    if user == receiver
      errors.add(:base, "User can't be requested")
    end
  end

  def associated_user(viewer)
    if viewer == user
      receiver
    else
      user
    end
  end

end
