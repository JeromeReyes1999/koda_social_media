class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :inviter, class_name: "User", optional: true
  enum roles: [:admin, :moderator, :normal]
  validates_uniqueness_of :user_id, scope: :group_id

  MANAGER_ROLES = [
    :admin, :moderator
  ].freeze

  PREVIOUS_MEMBER_STATES = [
    :left, :declined, :removed, :suspended
  ].freeze

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :accepted, :suspended, :left, :declined, :removed

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :leave do
      transitions from: :accepted, to: :left
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :remove do
      transitions from: :accepted, to: :removed
    end

    event :reenter do
      transitions from: [:left, :decline, :removed], to: :pending
    end
  end

  def suspend
    update(is_suspended: true)
  end

  def invited?
    inviter.present?
  end
end