class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!


  def index
    admin = !current_user.nil? && current_user.admin?
    if admin
          redirect_to admin_index_path
    else
          redirect_to events_path
    end
  end
end
