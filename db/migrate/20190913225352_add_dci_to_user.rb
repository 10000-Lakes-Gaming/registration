# frozen_string_literal: true

class AddDciToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :dci_number, :integer
  end
end
