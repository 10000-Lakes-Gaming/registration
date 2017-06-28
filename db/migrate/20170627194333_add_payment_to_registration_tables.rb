class AddPaymentToRegistrationTables < ActiveRecord::Migration[5.0]
  def change
    add_column :registration_tables, :paid, :boolean, default: false
    add_column :registration_tables, :payment_amount, :integer
    add_column :registration_tables, :payment_id, :string
  end
end
