class AddGroupRelatedColumnsInPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :remarks, :string
    add_column :posts, :state, :string
    add_reference :posts, :admin
    add_reference :posts, :group
  end
end
