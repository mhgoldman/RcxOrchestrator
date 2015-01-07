class WelcomeController < ApplicationController
	skip_before_action :authenticate_user!
	before_action :redirect_to_dashboard, only: :index
	
	def index
	end

	private

	def redirect_to_dashboard
		redirect_to batches_path if user_signed_in?
	end
end
