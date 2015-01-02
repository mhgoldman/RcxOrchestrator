class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Can't do anything in this app without authentication!
  before_filter :authenticate_user!


  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit([:email, :current_password, :password, :password_confirmation] | User.rcx_user_attributes ) } 
  end
end