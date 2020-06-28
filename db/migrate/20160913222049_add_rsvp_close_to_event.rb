class AddRsvpCloseToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :rsvp_close, :datetime
  end
end
