# frozen_string_literal: true

class AddOnlineToTable < ActiveRecord::Migration[5.2]
  def change
    add_column :tables, :online, :boolean, default: false
  end
end
