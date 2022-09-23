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

  def associated_users
    User.where(id: request_senders).or(User.where(id: request_receivers))
  end

  def all_requests
    requests_sent.or(requests_received)
  end
end
