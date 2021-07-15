# frozen_string_literal: true

class AddOptionalFeeToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :optional_fee, :boolean
  end
end
