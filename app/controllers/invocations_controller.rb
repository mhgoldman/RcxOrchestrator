class InvocationsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: :update
	skip_before_action :authenticate_user!, only: :update

	def index
		if params[:step_id]
			@step = Step.find(params[:step_id])
			@invocations = Invocation.where(step: @step)
			@batch = @step.batch
			@command = @step.command
		elsif params[:batch_id] && params[:client_id]
			@client = Client.find(params[:client_id])
			@batch = Batch.find(params[:batch_id])
			@invocations = ClientBatch.get(@client, @batch).invocations

			@client_name = @client.display_name
		end
	end

	def show
		@invocation = Invocation.find(params[:id])
		@client = @invocation.client
		@step = @invocation.step
		@command = @step.command
		@batch = @step.batch
	end

	def update
		@invocation = Invocation.find(params[:id])
		result = JSON.parse(request.body.read)
		if @invocation.process_callback(result)
			render nothing: true, status: :ok
		else
			render nothing: true, status: :forbidden
		end
	end	
end
