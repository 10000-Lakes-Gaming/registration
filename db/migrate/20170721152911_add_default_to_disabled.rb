class AddDefaultToDisabled < ActiveRecord::Migration[5.0]
  def change
    change_column_default :tables, :disabled, false
  end
end
