class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if user_signed_in? && current_user.admin?
          redirect_to admin_index_path
    else
          redirect_to events_path
    end
  end
end
