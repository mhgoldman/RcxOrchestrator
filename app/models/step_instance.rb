class StepInstance < ActiveRecord::Base
	belongs_to :step
	belongs_to :rcx_client

	def next_step_instance
		step.batch.steps.find_by(index: step.index+1)
	end
end
