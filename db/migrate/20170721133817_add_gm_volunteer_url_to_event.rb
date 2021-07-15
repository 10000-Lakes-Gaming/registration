# frozen_string_literal: true

class AddGmVolunteerUrlToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :gm_volunteer_link, :string
  end
end
