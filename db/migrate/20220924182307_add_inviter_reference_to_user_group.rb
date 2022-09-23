class AddInviterReferenceToUserGroup < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_groups, :inviter
  end
end
