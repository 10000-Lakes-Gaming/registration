# frozen_string_literal: true

class FixSystemColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :scenarios, :system, :game_system
  end
end
