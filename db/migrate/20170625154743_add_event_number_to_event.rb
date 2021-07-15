# frozen_string_literal: true

class AddEventNumberToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :event_number, :integer
  end
end
