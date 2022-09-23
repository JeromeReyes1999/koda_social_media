class AddProvinceToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :province, :string
  end
end
