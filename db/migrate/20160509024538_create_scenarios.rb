class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.string :type
      t.integer :season
      t.integer :scenario_number
      t.string :name
      t.string :description
      t.string :author
      t.string :paizo_url
      t.boolean :hard_mode

      t.timestamps null: false
    end
  end
end
