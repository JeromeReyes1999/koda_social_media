class CreateUserGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :user_groups do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.integer :roles
      t.string :state
      t.timestamps
    end
  end
end
