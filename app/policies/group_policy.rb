class GroupPolicy < ApplicationPolicy
  def home?
    user.user_groups.accepted.find_by(group: record).present?
  end

  def invite_friends?
    record.can_invite? && record.member?(user) && !record.user_groups.find_by(user: user).is_suspended
  end

  def invite?
    invite_friends?
  end

  def member_management?
    record.user_groups.where(user: user).where.not(roles: :normal).present?
  end

  def destroy?
    record.owner == user
  end

  def change_privacy?
    record.owner == user
  end

  class Scope < Scope
    def resolve
      user_group = user.user_groups.find_by(group: scope)
      if user_group.admin?
        scope.user_groups.where.not(user: [scope.owner, user]).accepted
      elsif user_group.moderator?
        scope.user_groups.where.not(user: [scope.owner, user]).accepted.where.not(roles: :admin)
      end
    end
  end
end
