# frozen_string_literal: true

class AddCharityToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :charity, :boolean
    add_column :events, :price, :integer
  end
end
