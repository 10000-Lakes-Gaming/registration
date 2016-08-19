module ApplicationHelper

  def admin?
    !current_user.nil? and current_user.admin?
  end

end
