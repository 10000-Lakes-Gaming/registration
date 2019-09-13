class AddDciToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :dci_number, :number
  end
end
