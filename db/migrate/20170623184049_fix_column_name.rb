# frozen_string_literal: true

class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :scenarios, :type, :type_of
  end
end
