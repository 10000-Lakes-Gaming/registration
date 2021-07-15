# frozen_string_literal: true

class AddInfoToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :info, :string
  end
end
