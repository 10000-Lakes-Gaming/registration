class AddDefaultPadToUserEvent < ActiveRecord::Migration[5.0]
  def up
    change_column_default :user_events, :paid, false
    UserEvent.find_each do |ue|
      if ue.paid.nil?
        ue.paid = false
        ue.save!
      end
    end
  end
end
