class AddRsvpCloseToEvent < ActiveRecord::Migration
  def change
    add_column :events, :rsvp_close, :datetime
  end
end
