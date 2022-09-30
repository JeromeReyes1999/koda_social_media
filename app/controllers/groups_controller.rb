class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:new, :create]

  def home
    authorize @group, :home?, policy_class: GroupPolicy
    @posts = @group.posts.published
  end

  def member_management
    authorize @group, :member_management?, policy_class: GroupPolicy
    @pending_member_records = @group.user_groups.includes(:user).pending if params[:manage_members] == 'Pending approval'
    @member_records = policy_scope(@group).includes(:user) if params[:manage_members] != 'Pending approval'
  end

  def change_privacy
    authorize @group, :change_privacy?, policy_class: GroupPolicy
    if @group.update(privacy: params[:privacy])
      flash[:notice] = "privacy is succesfully changed to #{params[:privacy]}"
    else
      flash[:alert] = @group.errors.full_messages.join(', ')
    end
    redirect_to group_home_path(@group)
  end

  def new
    @group = Group.new
  end

  def show; end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    if @group.save
      flash[:notice] = "Successfully created!"
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def destroy
    authorize @group, :destroy?, policy_class: GroupPolicy
    if @group.destroy
      flash[:notice] = "Your Group is Successfully deleted!"
    else
      flash[:alert] = @group.errors.full_messages.join(', ')
    end
    redirect_to user_groups_path(group_record: 'Find groups')
  end

  def join
    if @user_group = current_user.user_groups.where(state: UserGroup::PREVIOUS_MEMBER_STATES).find_by(group: @group)
      @user_group.roles = :normal
      @user_group.reenter!
      accept_if_unrestricted
    else
      @user_group = UserGroup.new
      @user_group.user = current_user
      @user_group.roles = :normal
      @user_group.group = @group
      if @user_group.save
        accept_if_unrestricted
      else
        flash[:alert] = @user_group.errors.full_messages.join(', ')
      end
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  def invite_friends
    authorize @group, :invite_friends?, policy_class: GroupPolicy
    @uninvited_friends = current_user.friends.where.not(id: @group.user_groups.where(state: [:pending, :accepted]).pluck(:user_id))
  end

  def invite
    @user = User.find(params[:user_id])
    authorize @group, :invite?, policy_class: GroupPolicy
    authorize @user, :friend?, policy_class: UserPolicy
    if @user_group = @user.user_groups.where(state: UserGroup::PREVIOUS_MEMBER_STATES).find_by(group: @group)
      @user_group.inviter = current_user
      @user_group.reenter!
    else
      @user_group = UserGroup.new
      @user_group.user = @user
      @user_group.inviter = current_user
      @user_group.group = @group
      if @user_group.save
        flash[:notice] = "successfully invited"
      else
        flash[:alert] = @user_group.errors.full_messages.join(', ')
      end
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  private

  def accept_if_unrestricted
    if @user_group.group.unrestricted?
      @user_group.accept!
      flash[:notice] = "Successfully joined!"
    else
      flash[:notice] = "request to join is submitted!"
    end
  end

  def set_group
    @group = Group.find(params[:id] || params[:group_id])
  end

  def group_params
    params.require(:group).permit(:name, :banner, :description, :privacy, :can_invite)
  end


end