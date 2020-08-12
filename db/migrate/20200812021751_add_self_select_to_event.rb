class AddSelfSelectToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :gm_self_select, :boolean
  end
end
