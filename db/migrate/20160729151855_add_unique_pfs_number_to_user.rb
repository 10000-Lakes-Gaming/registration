class AddUniquePfsNumberToUser < ActiveRecord::Migration
  def change
    add_index :users, :pfs_number, unique: true
  end
end
