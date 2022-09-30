class UserGroupPolicy < ApplicationPolicy
  def accept?
    record.user == user && record.may_accept? && record.invited?
  end

  def decline?
    record.user == user && record.may_decline? && record.invited?
  end

  def change_role?
    user.subordinates(record[:group]).include? record[:form_params].to_sym
  end

  def approve?
    user_manager? && record.may_accept? && !record.invited?
  end

  def remove?
    user_owner_or_moderator? && record.may_remove?
  end

  def change_suspension?
    user_manager?
  end

  def reject?
    user_owner_or_moderator? && record.may_reject?
  end

  def leave?
    record.user == user && record.may_leave? && record.group.owner != user
  end

  private

  def user_owner_or_moderator?
    user.user_groups.find_by(group: record.group).moderator? || record.group.owner == user
  end

  def user_manager?
    user.user_groups.where(group: record.group).where.not(roles: :normal).present?
  end
end
