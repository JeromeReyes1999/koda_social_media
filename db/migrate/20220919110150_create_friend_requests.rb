class CreateFriendRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :friend_requests do |t|
      t.belongs_to :user
      t.belongs_to :receiver
      t.integer :state
      t.timestamps
    end
  end
end
