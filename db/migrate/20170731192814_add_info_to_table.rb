class AddInfoToTable < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :information, :string
  end
end
