class ClientBatchCommandsController < ApplicationController
	def index
		if params[:batch_command_id]
			@batch_command = BatchCommand.find(params[:batch_command_id])
			@client_batch_commands = ClientBatchCommand.where(batch_command: @batch_command)
			@batch = @batch_command.batch
			@command = @batch_command.command
		elsif params[:batch_id] && params[:rcx_client_id]
			@rcx_client = RcxClient.find(params[:rcx_client_id])
			@batch = Batch.find(params[:batch_id])
			@client_batch_commands = @batch.client_batch_commands_by_rcx_client(@rcx_client)

			@rcx_client_name = @rcx_client.display_name
		end
	end

	def show
		@client_batch_command = ClientBatchCommand.find(params[:id])
		@rcx_client = @client_batch_command.rcx_client
		@batch_command = @client_batch_command.batch_command
		@command = @batch_command.command
		@batch = @batch_command.batch
	end
end
