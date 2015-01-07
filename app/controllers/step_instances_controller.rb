class StepInstancesController < ApplicationController
	def index
		if params[:step_id]
			@step = Step.find(params[:step_id])
			@step_instances = StepInstance.where(step: @step)
			@batch = @step.batch
			@command = @step.command
		elsif params[:batch_id] && params[:rcx_client_id]
			@view_by = :rcx_client
			@rcx_client = RcxClient.find(params[:rcx_client_id])
			@batch = Batch.find(params[:batch_id])
			@step_instances = @batch.step_instances_by_rcx_client(@rcx_client)

			@rcx_client_name = @rcx_client.display_name
		end
	end
end
