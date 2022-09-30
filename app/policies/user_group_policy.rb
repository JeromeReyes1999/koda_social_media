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
    UserGroup::MANAGER_ROLES.map(&:to_s).include?(user.user_groups.find_by(group: record.group).roles) && record.may_accept? && !record.invited?
  end

  def leave?
    record.user == user && record.may_leave? && !record.group.owner == user
  end
end
