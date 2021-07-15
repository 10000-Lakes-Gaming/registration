# frozen_string_literal: true

class AddTableToGamemaster < ActiveRecord::Migration[5.0]
  def change
    add_column :game_masters, :table_number, :string
  end
end
