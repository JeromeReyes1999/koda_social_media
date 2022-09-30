class Report < ApplicationRecord
  validates :reason, :state, presence: true

  belongs_to :user
  belongs_to :admin

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :reprimanded, :cleared

    event :reprimand do
      transitions from: :pending, to: :reprimanded
    end

    event :clear do
      transitions from: :pending, to: :cleared
    end
  end

end
