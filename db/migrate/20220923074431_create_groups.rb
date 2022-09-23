class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :banner
      t.belongs_to :owner
      t.integer :privacy
      t.boolean :can_invite
      t.timestamps
    end
  end
end
