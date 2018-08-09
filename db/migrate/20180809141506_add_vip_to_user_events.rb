class AddVipToUserEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :vip, :boolean
  end
end
