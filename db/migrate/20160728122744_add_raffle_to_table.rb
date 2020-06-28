class AddRaffleToTable < ActiveRecord::Migration[5.2]
  def change
    add_column :tables, :raffle, :boolean, default: false
    add_column :tables, :core, :boolean, default: false
  end
end
