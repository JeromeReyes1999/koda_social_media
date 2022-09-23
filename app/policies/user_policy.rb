class UserPolicy < ApplicationPolicy
  def friend?
    user.friend?(record)
  end
end
