class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.belongs_to :user
      t.belongs_to :admin
      t.string :reason
      t.integer :state
      t.timestamps
    end
  end
end
