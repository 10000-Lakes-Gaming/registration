# frozen_string_literal: true

class AddChatToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :chat_server, :string
    add_column :events, :chat_server_url, :string
  end
end
