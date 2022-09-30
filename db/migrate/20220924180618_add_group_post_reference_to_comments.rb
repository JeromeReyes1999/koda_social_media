class AddGroupPostReferenceToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :group_post
  end
end
