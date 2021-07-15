# frozen_string_literal: true

class AddForumUsernameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :forum_username, :string
  end
end
