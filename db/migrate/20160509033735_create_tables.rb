class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.references :session, index: true, foreign_key: true
      t.references :scenario, index: true, foreign_key: true
      t.integer :max_players

      t.timestamps null: false
    end
  end
end
