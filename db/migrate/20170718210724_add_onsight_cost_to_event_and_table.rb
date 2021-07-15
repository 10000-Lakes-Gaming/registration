# frozen_string_literal: true

class AddOnsightCostToEventAndTable < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :onsite_price, :integer, default: 0
    add_column :events, :prereg_ends, :datetime
    add_column :tables, :onsite_price, :integer, default: 0

    rename_column :events, :price, :prereg_price
    rename_column :tables, :price, :prereg_price

    reversible do |dir|
      dir.up do
        Event.update_all('prereg_ends = rsvp_close')
      end
    end
  end
end
