class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  REQUEST_STATES = [
    'Find friends', 'Friends', 'Requests sent', 'Requests received'
  ].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :comments

  has_many :requests_sent, class_name: "FriendRequest"
  has_many :request_receivers, through: :requests_sent, source: :receiver
  has_many :requests_received, class_name: "FriendRequest", foreign_key: "receiver_id"
  has_many :request_senders, through: :requests_received, source: :user

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :group_posts

  def associated_users
    User.where(id: request_senders).or(User.where(id: request_receivers))
  end

  def all_requests
    requests_sent.or(requests_received)
  end

  def filter_associated_user_by_state(state)
    User.where(id: request_receivers).includes(:requests_received, :requests_sent).where(requests_received: { state: state })
        .or(User.where(id: request_senders).includes(:requests_received, :requests_sent).where(requests_sent: { state: state }))
  end

  def friend? (user)
    filter_associated_user_by_state(:accepted).find_by(id: user).present?
  end

  def friends
    filter_associated_user_by_state(:accepted)
  end

  def subordinates(group)
    user_group = user_groups.find_by(group: group)
    if user_group&.admin?
      [:admin, :moderator, :normal]
    elsif user_group&.moderator?
      [:moderator, :normal]
    end
  end
end
