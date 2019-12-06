class AddOptOutToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :opt_out, :boolean
  end
end
