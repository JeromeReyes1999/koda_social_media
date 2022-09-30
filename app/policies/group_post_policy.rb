class GroupPostPolicy < ApplicationPolicy
  def member?
    record.user_groups.accepted.find_by(user: user)
  end

  def show_remove?
    (user.user_groups.find_by(group: record.group).moderator? || record.group.owner == user) && record.user.user_groups.where(group: record.group).where(roles: :normal).present?
  end

  def remove?
    show_remove?
  end

  def reject?
    user_manager?
  end

  def publish?
    user_manager?
  end

  private

  def user_manager?
    user.user_groups.where(group: record.group).where.not(roles: :normal).present?
  end
end
