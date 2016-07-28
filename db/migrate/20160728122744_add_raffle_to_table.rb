class AddRaffleToTable < ActiveRecord::Migration
  def change
    add_column :tables, :raffle, :boolean, default: false
    add_column :tables, :core, :boolean, default: false
  end
end
