class StepInstance < ActiveRecord::Base
	belongs_to :step
	belongs_to :rcx_client

	def start!
		raise 'Already started' if started?

		result = rcx_client.invoke_command(step.command)
		update_from_client_result(result)
	end

	def refresh_status
		raise 'Not yet started' unless started?

		result = rcx_client.command_status(self.client_guid)
		update_from_client_result(result)
		self
	end

	def started?
		!client_guid.nil?
	end

	def finished?
		has_exited
	end

	def succeeded?
		has_exited && exit_code == 0
	end

	def next_step_instance
		next_step_in_batch = step.batch.steps.find_by(index: step.index + 1)
		StepInstance.find_by(rcx_client: rcx_client, step_id: next_step_in_batch)
	end

	def reset_status
		update_from_client_result({})
	end

	private

	def update_from_client_result(result)
		self.client_guid = result['Guid']
		self.has_exited = result['HasExited']
		self.exit_code = result['ExitCode']
		self.standard_error = result['StandardError']
		self.standard_output = result['StandardOutput']
		self.save
	end	
end
