# frozen_string_literal: true

class UpdatesForTableTopEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :tables, :tabletop_events, :boolean, default: false
    add_column :tables, :sent_to_tabletop_events, :boolean, default: false
    add_column :events, :tabletop_event_type_code, :string
  end
end
