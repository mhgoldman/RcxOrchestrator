class ClientBatchCommand < ActiveRecord::Base
	STATUSES = [:finished, :running, :queued, :errored, :blocked]

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
		if errored?
			:errored			
		elsif blocked?
			:blocked
		elsif !started?
			:queued
		elsif running?
			:running
		elsif finished?
			:finished
		end
	end

	def result
		return nil unless finished?
		exit_code == 0 ? :succeeded : :failed
	end

	def blocked?
		previous = previous_client_batch_command
		!!previous && (previous.errored? || previous.blocked?)
	end

	def started?
		!client_guid.nil?
	end

	def running?
		started? && !over?
	end

	def errored?
		!!error
	end

	def over?
		finished? || errored? || blocked?
	end

	def finished?
		has_exited
	end

	def succeeded?
		result == :succeeded
	end

	def failed?
		result == :failed
	end

	def next_client_batch_command
		relative_client_batch_command(1)
	end

	def previous_client_batch_command
		relative_client_batch_command(-1)
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

	def relative_client_batch_command(offset)
		relative = batch_command.batch.batch_commands.find_by(index: batch_command.index + offset)
		ClientBatchCommand.find_by(rcx_client: rcx_client, batch_command_id: relative)
	end	
end
