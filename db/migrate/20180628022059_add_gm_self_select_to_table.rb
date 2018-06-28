class AddGmSelfSelectToTable < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :gm_self_select, :boolean, default: true
  end
end
