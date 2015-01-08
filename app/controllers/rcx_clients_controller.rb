class RcxClientsController < ApplicationController
	def index
		@rcx_clients = current_user.rcx_clients.all
	end

	def show
		@rcx_client = current_user.rcx_clients.find(params[:id])
	end

	def start_client_update
		FetchRcxClientsJob.perform_later(current_user)
		redirect_to rcx_clients_path
	end
end
