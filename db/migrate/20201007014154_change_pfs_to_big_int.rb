class ChangePfsToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :pfs_number, :bigint
  end
end
