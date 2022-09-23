class FriendRequestPolicy < ApplicationPolicy
  def accept?
    record.receiver == user && record.pending?
  end

  def decline?
    record.receiver == user && record.pending?
  end

  def cancel?
    record.user == user && record.pending?
  end

  def unfriend?
    (record.user == user || record.receiver == user) && record.accepted?
  end
end
