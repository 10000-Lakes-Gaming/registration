class AddFeeToUserEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :donation, :integer
  end
end
