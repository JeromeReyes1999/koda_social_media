class AddCityToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :city, :string
  end
end
