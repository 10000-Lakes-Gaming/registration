# frozen_string_literal: true

class AddReceiptToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :payment_id, :string
    add_column :user_events, :payment_amount, :integer
  end
end
