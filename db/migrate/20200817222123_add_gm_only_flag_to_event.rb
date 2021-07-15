# frozen_string_literal: true

class AddGmOnlyFlagToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :gm_select_only, :boolean
  end
end
