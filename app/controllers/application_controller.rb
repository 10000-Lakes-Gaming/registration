class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :pfs_number
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # added for Devise
  before_action :authenticate_user!
  # puts("Authenticated? " + user_signed_in?)
  # def after_sign_in_path_for (resource)
  #
  # end

  # def after_sign_in_path_for(resource)
  #   current_user_path
  # end

  def restrict_to_admin
    if !current_user.admin?
      flash[:notice] = "You are not authorized to view that page."
      redirect_to root_path
    end
  end

end
