class AddDisableToTable < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :disabled, :boolean
  end
end
