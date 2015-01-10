class ClientBatchCommandsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: :update
	skip_before_action :authenticate_user!, only: :update

	def index
		if params[:batch_command_id]
			@batch_command = BatchCommand.find(params[:batch_command_id])
			@client_batch_commands = ClientBatchCommand.where(batch_command: @batch_command)
			@batch = @batch_command.batch
			@command = @batch_command.command
		elsif params[:batch_id] && params[:client_id]
			@client = Client.find(params[:client_id])
			@batch = Batch.find(params[:batch_id])
			@client_batch_commands = @batch.client_batch_commands_by_client(@client)

			@client_name = @client.display_name
		end
	end

	def show
		@client_batch_command = ClientBatchCommand.find(params[:id])
		@client = @client_batch_command.client
		@batch_command = @client_batch_command.batch_command
		@command = @batch_command.command
		@batch = @batch_command.batch
	end

	def update
		@client_batch_command = ClientBatchCommand.find(params[:id])
		result = JSON.parse(request.body.read)
		if @client_batch_command.process_callback(result)
			render nothing: true, status: :ok
		else
			render nothing: true, status: :forbidden
		end
	end	
end
