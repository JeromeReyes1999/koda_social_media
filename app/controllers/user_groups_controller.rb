class UserGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_group, except: :index

  def index
    @user_groups = current_user.user_groups.includes(:group).pending.where.not(inviter: nil) if params[:group_record] == "Group invited"
    @user_groups = current_user.user_groups.includes(:group).pending.where(inviter: nil) if params[:group_record] == "Pending Approval"
    @user_groups = current_user.user_groups.includes(:group).accepted if params[:group_record] == "Groups"
    @non_associated_groups = Group.where.not(id: current_user.user_groups.where.not(state: :left).pluck(:group_id)) if @user_groups.nil?
  end

  def leave
    authorize @user_group, policy_class: UserGroupPolicy
    if @user_group.may_leave? && @user_group.leave!
      flash[:notice] = "you have successfully left!"
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  def change_role
    record = {form_params: params[:user_group][:roles], group: @user_group.group}
    authorize record, policy_class: UserGroupPolicy
    if policy_scope(@user_group.group).find(@user_group.id).update(roles: params[:user_group][:roles])
      flash[:notice] = "Successfully Updated"
    else
      flash[:alert] = @user_group.errors.full_messages.user(', ')
    end
    redirect_to request.referrer || group_path(@user_group.group)
  end

  def decline
    authorize @user_group, policy_class: UserGroupPolicy
    if @user_group.may_decline? && @user_group.decline!
      flash[:notice] = "the request has been declined!"
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  def accept
    authorize @user_group, policy_class: UserGroupPolicy
    if @user_group.may_accept? && @user_group.accept!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  def approve
    authorize @user_group, policy_class: UserGroupPolicy
    if @user_group.may_accept? && @user_group.accept!
      flash[:notice] = 'Successfully accepted'
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
    end
    redirect_to request.referrer || user_groups_path(group_record: 'Find groups')
  end

  def suspend; end

  def reinstate; end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:user_group_id])
  end
end