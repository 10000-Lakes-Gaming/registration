# frozen_string_literal: true

class AddOnlineSalesEndToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :online_sales_end, :datetime
  end
end
