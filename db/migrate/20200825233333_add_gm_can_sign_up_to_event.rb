class AddGmCanSignUpToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :gm_signup, :boolean
  end
end
