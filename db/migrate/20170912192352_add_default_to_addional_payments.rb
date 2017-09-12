class AddDefaultToAddionalPayments < ActiveRecord::Migration[5.0]
  def change
    change_column_default :additional_payments, :market_price, 0
    change_column_default :additional_payments, :charitable_donation, false
    change_column_default :additional_payments, :payment_price, 0
  end
end
