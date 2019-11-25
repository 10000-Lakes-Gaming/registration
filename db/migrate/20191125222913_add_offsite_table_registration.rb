class AddOffsiteTableRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :tables_reg_offsite, :boolean, default: false
  end
end
