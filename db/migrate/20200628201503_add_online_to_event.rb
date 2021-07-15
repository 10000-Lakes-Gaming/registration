# frozen_string_literal: true

class AddOnlineToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :in_person, :boolean, default: true
    add_column :events, :online, :boolean, default: false
  end
end
