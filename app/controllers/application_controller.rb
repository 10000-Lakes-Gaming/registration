class ApplicationController < ActionController::Base


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # added for Devise
  before_action :authenticate_user!
  # puts("Authenticated? " + user_signed_in?)
  # def after_sign_in_path_for (resource)
  #
  # end

  def restrict_to_admin
    if !current_user.admin?
      flash[:notice] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end

end
