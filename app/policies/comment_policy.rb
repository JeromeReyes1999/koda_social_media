class CommentPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def edit?
    update?
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
