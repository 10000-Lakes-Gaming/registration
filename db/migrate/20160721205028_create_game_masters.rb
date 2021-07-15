# frozen_string_literal: true

class CreateGameMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :game_masters do |t|
      t.belongs_to :table, index: true, foreign_key: true
      t.belongs_to :user_event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
