class AddPremiumToTable < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :premium, :boolean
    add_column :tables, :price, :integer
  end
end
