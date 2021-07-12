class AddAttendancePolicyToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :attendance_policy, :text
  end
end
