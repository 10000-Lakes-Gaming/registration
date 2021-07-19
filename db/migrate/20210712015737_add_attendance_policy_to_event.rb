# frozen_string_literal: true

class AddAttendancePolicyToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :attendance_policy, :text
    add_column :events, :tee_shirt_price, :integer
    add_column :events, :tee_shirt_end, :date
  end
end
