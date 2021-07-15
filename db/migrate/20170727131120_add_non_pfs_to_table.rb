# frozen_string_literal: true

class AddNonPfsToTable < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :non_pfs, :boolean
  end
end
