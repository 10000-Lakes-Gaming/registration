class AddGameMasterToTable < ActiveRecord::Migration[5.2]
  def change
    add_column :tables, :gms_needed, :integer, default: 1
  end
end
