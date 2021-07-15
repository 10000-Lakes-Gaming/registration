# frozen_string_literal: true

class AddEvergreenToScenario < ActiveRecord::Migration[5.0]
  def change
    add_column :scenarios, :evergreen, :boolean
  end
end
