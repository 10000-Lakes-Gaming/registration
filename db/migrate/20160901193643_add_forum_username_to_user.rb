class AddForumUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :forum_username, :string
  end
end
