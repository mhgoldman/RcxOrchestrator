class ClientsController < ApplicationController
	def index
		@clients = current_user.clients.all
	end

	def show
		@client = current_user.clients.find(params[:id])
	end

	def create
		FetchClientsJob.perform_later(current_user)
		redirect_to clients_path
	end
end
