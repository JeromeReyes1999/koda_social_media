class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :audience
      t.string :location
      t.string :text
      t.string :image
      t.belongs_to :user
      t.timestamps
    end
  end
end
