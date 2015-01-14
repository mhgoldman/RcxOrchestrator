class ClientStepsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: :update
	skip_before_action :authenticate_user!, only: :update

	def index
		if params[:step_id]
			@step = Step.find(params[:step_id])
			@client_steps = ClientStep.where(step: @step)
			@batch = @step.batch
			@command = @step.command
		elsif params[:batch_id] && params[:client_id]
			@client = Client.find(params[:client_id])
			@batch = Batch.find(params[:batch_id])
			@client_steps = @batch.client_steps_by_client(@client)

			@client_name = @client.display_name
		end
	end

	def show
		@client_step = ClientStep.find(params[:id])
		@client = @client_step.client
		@step = @client_step.step
		@command = @step.command
		@batch = @step.batch
	end

	def update
		@client_step = ClientStep.find(params[:id])
		result = JSON.parse(request.body.read)
		if @client_step.process_callback(result)
			render nothing: true, status: :ok
		else
			render nothing: true, status: :forbidden
		end
	end	
end
