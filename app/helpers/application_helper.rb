module ApplicationHelper

  def admin?
    !current_user.nil? and current_user.admin?
  end

  def yes_no (value)
    value ? "Yes" : "No"
  end
end
