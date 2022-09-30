class GroupPostPolicy < ApplicationPolicy
  def member?
    record.user_groups.accepted.find_by(user: user)
  end
end
