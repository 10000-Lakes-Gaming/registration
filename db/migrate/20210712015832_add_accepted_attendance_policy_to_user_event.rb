# frozen_string_literal: true

class AddAcceptedAttendancePolicyToUserEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :accepted_attendance_policy, :boolean
    # Must now explicitly choose. Hopefully can work something on the front end to default this.
    add_column :user_events, :online, :boolean
    add_column :user_events, :in_person, :boolean
    # null means no tee shirt.
    add_column :user_events, :tee_shirt_size, :string

    # Should update all previous rows to set the online and in_person flags.
    events = Event.all
    events.each do |event|
      event.user_events.each do |ue|
        ue.online = event.online
        ue.in_person = event.in_person
        ue.save!
      end
    end
  end
end
