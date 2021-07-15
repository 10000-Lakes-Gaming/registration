# frozen_string_literal: true

class AddPregenToScenario < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :pregen_only, :boolean
  end
end
