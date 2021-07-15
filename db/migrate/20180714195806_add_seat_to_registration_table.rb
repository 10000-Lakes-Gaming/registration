# frozen_string_literal: true

class AddSeatToRegistrationTable < ActiveRecord::Migration[5.0]
  def change
    add_column :registration_tables, :seat, :integer
  end
end
