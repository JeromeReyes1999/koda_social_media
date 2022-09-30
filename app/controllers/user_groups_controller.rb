class UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_group, except: :index

  def index
    @user_groups = current_user.user_groups.includes(:group).pending.where.not(inviter: nil) if params[:group_record] == "Group invited"
    @user_groups = current_user.user_groups.includes(:group).pending.where(inviter: nil) if params[:group_record] == "Pending Approval"
    @user_groups = current_user.user_groups.includes(:group).accepted if params[:group_record] == "Groups"
    @non_associated_groups = Group.where.not(id: current_user.user_groups.where.not(state: UserGroup::PREVIOUS_MEMBER_STATES).pluck(:group_id)) if @user_groups.nil?
  end

  def leave
    authorize @user_group, :leave?, policy_class: UserGroupPolicy
    if @user_group.may_leave? && @user_group.leave!
      flash[:notice] = "you have successfully left!"
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to user_groups_path(group_record: "Groups")
  end

  def change_role
    record = {form_params: params[:user_group][:roles], group: @user_group.group}
    authorize record, :change_role?, policy_class: UserGroupPolicy
    if policy_scope(@user_group.group).find(@user_group.id).update(roles: params[:user_group][:roles])
      flash[:notice] = "Successfully Updated"
    else
      flash[:alert] = @user_group.errors.full_messages.user(', ')
    end
    redirect_to group_member_management_path(@user_group.group, management: 'Manage members')
  end

  def decline
    authorize @user_group, :decline?, policy_class: UserGroupPolicy
    if @user_group.may_decline? && @user_group.decline!
      flash[:notice] = "the request has been declined!"
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to user_groups_path(group_record: "Group invited")
  end

  def accept
    authorize @user_group, :accept?, policy_class: UserGroupPolicy
    if @user_group.may_accept? && @user_group.accept!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to user_groups_path(group_record: "Group invited")
  end

  def approve
    authorize @user_group, :approve?, policy_class: UserGroupPolicy
    if @user_group.may_accept? && @user_group.accept!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to group_member_management_path(@user_group.group, management: 'Pending approval')
  end

  def reject
    authorize @user_group, :reject?, policy_class: UserGroupPolicy
    if @user_group.may_dec && @user_group.accept!
      flash[:notice] = 'Successfully rejected'
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to group_member_management_path(@user_group.group, management: 'Pending approval')
  end

  def remove
    authorize @user_group, :remove?, policy_class: UserGroupPolicy
    if @user_group.may_remove? && @user_group.remove!
      flash[:notice] = "user is successfully removed!"
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to group_member_management_path(@user_group.group, management: 'Manage members')
  end

  def change_suspension
    authorize @user_group, :change_suspension?, policy_class: UserGroupPolicy
    if @user_group.update(is_suspended: params[:is_suspended])
      flash[:notice] = "Successfully Updated"
    else
      flash[:alert] = @user_group.errors.full_messages.user(', ')
    end
    redirect_to group_member_management_path(@user_group.group, management: 'Manage members')
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end
end