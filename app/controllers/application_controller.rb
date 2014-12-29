class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_skytap_credentials

  protected

  def set_skytap_credentials
    RequestStore.store[:skytap_username] = 'mgoldman@spcapitaliq.com'
    RequestStore.store[:skytap_api_token] = '68a23c6a5101225f6f43db27050896e6580cbc20'
  end
end
