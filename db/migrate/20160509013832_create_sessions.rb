# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.belongs_to :event, index: true, foreign_key: true
      t.string :name
      t.datetime :start
      t.datetime :end

      t.timestamps null: false
    end
  end
end
