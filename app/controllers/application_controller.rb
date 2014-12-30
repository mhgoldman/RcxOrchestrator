class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_skytap_credentials

  protected

  def set_skytap_credentials
    RequestStore.store[:skytap_username] = current_user.settings[:skytap_username]
    RequestStore.store[:skytap_api_token] = current_user.settings[:skytap_api_token]
  end
end