# frozen_string_literal: true

class CreateAdditionalPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :additional_payments do |t|
      t.string :category
      t.string :description
      t.boolean :charitable_donation
      t.integer :market_price
      t.integer :payment_price
      t.integer :payment_amount
      t.string :payment_id
      t.datetime :payment_date
      t.references :user_event, foreign_key: true

      t.timestamps
    end
  end
end
