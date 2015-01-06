class RcxClientsController < ApplicationController
	def index
		@rcx_clients = current_user.rcx_clients.all
	end

	def start_client_update
		FetchRcxClientsJob.perform_later(current_user)
		redirect_to rcx_clients_path
	end
end
