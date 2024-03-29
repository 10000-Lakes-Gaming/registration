# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  def get_event
    @event = Event.find(params[:event_id])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name pfs_number forum_username dci_number])
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # added for Devise
  before_action :authenticate_user!

  def restrict_to_admin
    redirect_to root_path unless current_user.admin?
    true
  end

  def restrict_to_hosts
    redirect_to events_path unless event_host?
    true
  end

  def restrict_to_gamemaster
    redirect_to root_path unless event_host? || @game_master&.assigned(current_user)
    true
  end

  def force_to_current_user
    @user = current_user
  end

  def set_event
    @event = Event.find(params[:id])
  end

  private

  def authenticate_user!
    super unless $disable_authentication
  end
end
