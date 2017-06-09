class AddSystemToScenario < ActiveRecord::Migration[5.0]
  def change
    add_column :scenarios, :system, :string, :default => 'PFS'
  end
end
