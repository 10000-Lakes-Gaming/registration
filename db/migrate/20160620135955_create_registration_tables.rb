class CreateRegistrationTables < ActiveRecord::Migration
  def change
    create_table :registration_tables do |t|
      t.references :table, foreign_key: true
      t.references :user_event, foreign_key: true
      t.timestamps null: false
    end
  end
end
