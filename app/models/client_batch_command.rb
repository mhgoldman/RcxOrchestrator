class ClientBatchCommand < ActiveRecord::Base
	STATUSES = [:finished, :running, :queued, :error]

	belongs_to :batch_command
	belongs_to :rcx_client

	def start!
		raise 'Already started' if started?

		result = rcx_client.invoke_command(batch_command.command)
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

	def next_client_batch_command
		next_step_in_batch = batch_command.batch.batch_commands.find_by(index: batch_command.index + 1)
		ClientBatchCommand.find_by(rcx_client: rcx_client, batch_command_id: next_step_in_batch)
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
