class AddTierAndRetiredToScenario < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :tier, :string
    add_column :scenarios, :retired, :boolean, default: false
  end
end
