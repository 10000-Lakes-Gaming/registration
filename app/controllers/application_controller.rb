class ApplicationController < ActionController::Base
  before_action :reload_current_user
  before_filter :configure_permitted_parameters, if: :devise_controller?


  def get_event
    @event = Event.find(params[:event_id])
  end


  private
  def reload_current_user
    current_user.reload
  end

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
    unless current_user.admin?
      redirect_to root_path
    end
  end

  def force_to_current_user
    @user = current_user
  end

end
