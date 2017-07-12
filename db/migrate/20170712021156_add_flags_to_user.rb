class AddFlagsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gm_stars, :integer
    add_column :users, :venture_officer, :boolean
    add_column :users, :title, :string
  end
end
