# frozen_string_literal: true

class AddUniquePfsNumberToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :pfs_number, unique: true
  end
end
