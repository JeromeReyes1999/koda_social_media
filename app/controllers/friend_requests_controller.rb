class FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :create]
  before_action :set_friend_request, except: [:index, :create]

  def index
    @friend_requests = current_user.all_requests.accepted if params[:request_state] == 'Friends'
    @friend_requests = current_user.requests_sent.pending if params[:request_state] == 'Requests sent'
    @friend_requests = current_user.requests_received.pending if params[:request_state] == 'Requests received'
    @non_associated_users = User.where.not(id: current_user.associated_users).where.not(id: current_user) if @friend_requests.nil?
  end

  def create
    @friend_request = FriendRequest.new
    @friend_request.user = current_user
    @friend_request.receiver_id = params[:receiver_id]
    @friend_request.state = :pending
    if @friend_request.save
      flash[:notice]= 'Successfully Created'
    else
      flash[:alert] = @friend_request.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || friend_requests_path(request_state: 'Find friends')
  end

  def accept
    authorize @friend_request, :accept?, policy_class: FriendRequestPolicy
    if @friend_request.update(state: :accepted)
      flash[:notice] = 'Successfully Added'
    else
      flash[:alert] = @friend_request.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || friend_requests_path(request_state: 'Find friends')
  end

  def decline
    authorize @friend_request, :decline?, policy_class: FriendRequestPolicy
    if @friend_request.destroy
      flash[:notice] = "the request has been declined!"
    else
      flash[:alert] = @friend_request.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || friend_requests_path(request_state: 'Find friends')
  end

  def cancel
    authorize @friend_request, :cancel?, policy_class: FriendRequestPolicy
    if @friend_request.destroy
      flash[:notice] = "the request has been cancelled!"
    else
      flash[:alert] = @friend_request.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || friend_requests_path(request_state: 'Find friends')
  end

  def unfriend
    authorize @friend_request, :unfriend?, policy_class: FriendRequestPolicy
    if @friend_request.destroy
      flash[:notice] = "#{@friend_request.associated_user(current_user).email} has been removed from your friends list!"
    else
      flash[:alert] = @friend_request.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || friend_requests_path(request_state: 'Find friends')
  end

  private

  def set_friend_request
    @friend_request = FriendRequest.find(params[:friend_request_id])
  end
end