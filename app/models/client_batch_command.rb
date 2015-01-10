class ClientBatchCommand < ActiveRecord::Base
	STATUSES = [:finished, :running, :queued, :errored, :blocked]

	belongs_to :batch_command
	belongs_to :rcx_client	

	before_create :set_callback_token

	def start!
		raise 'Already started' if started?

		result = rcx_client.invoke(self)
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
		previous && (previous.errored? || previous.blocked?)
	end

	def started?
		!client_guid.nil?
	end

	def running?
		started? && !over?
	end

	def errored?
		fatally_errored?
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

	def exists?
		ClientBatchCommand.exists?(id)
	end

	def fatally_errored!
		update(fatally_errored: true)
	end

	def fatally_errored?
		fatally_errored
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

	def callback_url
		Rails.application.routes.url_helpers.client_batch_command_url(self, host: Rails.application.config.rcx_callback_host)
	end

	def process_callback(result)
		return false if result['CallbackToken'] != callback_token
		update_from_client_result(result)
		true
	end

	def append_error(error)
		new_error = (self.error ||= '') << error
		update(error: new_error)
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

	def set_callback_token
		self.callback_token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end
end
