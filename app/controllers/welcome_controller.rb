class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!


  def index
    unless current_user.nil?
      if current_user.admin?
        redirect_to admin_index_path
        return
      else
        redirect_to events_path
        return
      end
    end # current user not nil
  end
end
