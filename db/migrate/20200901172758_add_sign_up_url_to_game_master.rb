class AddSignUpUrlToGameMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :game_masters, :sign_in_url, :string
  end
end
