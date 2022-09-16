class AddDistrictToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :district, :string
  end
end
