class AddPregenToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :pregen_only, :boolean
  end
end
