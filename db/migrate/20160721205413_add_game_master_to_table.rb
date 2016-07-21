class AddGameMasterToTable < ActiveRecord::Migration
  def change
    add_column :tables, :gms_needed, :integer, default: 1
  end
end
