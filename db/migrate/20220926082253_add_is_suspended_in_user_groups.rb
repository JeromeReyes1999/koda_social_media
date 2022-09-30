class AddIsSuspendedInUserGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :user_groups, :is_suspended, :boolean, default: false
  end
end
