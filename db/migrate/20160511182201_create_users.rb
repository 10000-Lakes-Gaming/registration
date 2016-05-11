class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email_address
      t.integer :pfs_number
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
