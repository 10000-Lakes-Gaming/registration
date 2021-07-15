# frozen_string_literal: true

class RemoveUniqueFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :pfs_number
  end
end
