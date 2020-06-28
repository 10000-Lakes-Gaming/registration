class AddLocationToTable < ActiveRecord::Migration[5.2]
  def change
    add_column :tables, :location, :string
  end
end
