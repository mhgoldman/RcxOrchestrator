class StepInstancesController < ApplicationController
	def index
		@step = Step.find(params[:step_id])
		@step_instances = StepInstance.where(step: @step)
	end
end
