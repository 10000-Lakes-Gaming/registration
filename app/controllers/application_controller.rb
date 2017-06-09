class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?


  def get_event
    @event = Event.find(params[:event_id])
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :pfs_number])
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # added for Devise
  before_action :authenticate_user!

  def restrict_to_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end

  def force_to_current_user
    @user = current_user
  end

  private
  def authenticate_user!
    super unless $disable_authentication
  end

end
