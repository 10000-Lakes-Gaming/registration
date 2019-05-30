class CreateEventHosts < ActiveRecord::Migration[5.0]
  def change
    create_table :event_hosts do |t|
      t.date :start_date
      t.date :end_date
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
