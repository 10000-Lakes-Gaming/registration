# frozen_string_literal: true

class AddSelfSelectToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :gm_self_select, :boolean, default: true
  end
end
