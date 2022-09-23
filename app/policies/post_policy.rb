class PostPolicy < ApplicationPolicy
  def edit?
    update?
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def audience?
    if record.group.nil?
      record.everyone? || record.user == user || (record.friends_only && record.user.friend?(user))
    else
      record.group.member?(user)
    end
  end
end
