class AddAcceptedAttendancePolicyToUserEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :accepted_attendance_policy, :boolean
  end
end
