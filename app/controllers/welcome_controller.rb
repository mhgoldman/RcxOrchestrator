class WelcomeController < ApplicationController
	before_filter :redirect_to_dashboard, only: :index

	def index
	end

	private

	def redirect_to_dashboard
		redirect_to dashboard_path if user_signed_in?
	end
end
