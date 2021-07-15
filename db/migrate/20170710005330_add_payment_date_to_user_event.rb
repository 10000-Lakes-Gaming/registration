# frozen_string_literal: true

class AddPaymentDateToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :payment_date, :datetime
    add_column :registration_tables, :payment_date, :datetime
  end
end
