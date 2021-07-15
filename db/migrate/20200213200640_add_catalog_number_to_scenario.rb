# frozen_string_literal: true

class AddCatalogNumberToScenario < ActiveRecord::Migration[5.2]
  def change
    add_column :scenarios, :catalog_number, :string
  end
end
