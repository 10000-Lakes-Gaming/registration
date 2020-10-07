class ChangeDciToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :dci_number, :bigint
  end
end
