class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :welcome_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?

  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit([:email, :current_password, :password, :password_confirmation] | User.rcx_user_attributes ) } 
  end

  def welcome_controller?
    controller_name == 'welcome'
  end
end