# frozen_string_literal: true

class AddVttToGameMaster < ActiveRecord::Migration[5.2]
  def change
    add_column :game_masters, :vtt_type, :string
    add_column :game_masters, :vtt_name, :string
    add_column :game_masters, :vtt_url, :string

    puts 'Removing column default'
    change_column :scenarios, :game_system, :string, default: nil
  end
end
