class AddChatToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :chat_server, :string
  end
end
