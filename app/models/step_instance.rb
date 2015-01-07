class StepInstance < ActiveRecord::Base
	STATUSES = [:finished, :running, :queued, :error]

	belongs_to :step
	belongs_to :rcx_client

	def start!
		raise 'Already started' if started?

		result = rcx_client.invoke_command(step.command)
		update_from_client_result(result)
	end

	def refresh_status
		raise 'Not yet started' unless started?

		result = rcx_client.command_status(client_guid)
		update_from_client_result(result)
		self
	end

	def status
		if !error.nil?
			:error
		elsif !started?
			:queued
		elsif has_exited
			:finished
		else
			:running
		end
	end

	def result
		return nil unless finished?
		exit_code == 0 ? :succeeded : :failed
	end

	def started?
		!client_guid.nil?
	end

	def finished?
		[:finished, :error].include?(status)
	end

	def succeeded?
		result == :succeeded
	end

	def failed?
		result == :failed
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
		save!
	end	
end
