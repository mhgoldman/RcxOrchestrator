class Invocation < ActiveRecord::Base
	STATUSES = [:finished, :running, :queued, :errored, :blocked]

	#TODO! BROKEN! If this won't work, put back sort wherever invocations are listed!
	#default_scope { joins(:step).order('step.index')}

	belongs_to :step
	belongs_to :client_batch

	delegate :client, to: :client_batch
	delegate :index, to: :step

	before_create :set_callback_token

	def start!
		raise 'Already started' if started?

		result = client.invoke(self)
		update_from_client_result(result)
	end

	def refresh_status
		raise 'Not yet started' unless started?

		result = client.command_status(client_guid)
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
		p = previous
		p && (p.errored? || p.blocked?)
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
		Invocation.exists?(id)
	end

	def fatally_errored!
		update(fatally_errored: true)
	end

	def fatally_errored?
		fatally_errored
	end

	def next
		index >= (siblings.length-1) ? nil : siblings[index+1]
	end

	def previous
		index <= 0 ? nil : siblings[index-1]
	end

	def reset_status
		update_from_client_result({})
	end

	def callback_url
		Rails.application.routes.url_helpers.invocation_url(self, Rails.application.config.rcx_callback_url_options)
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

	def siblings
		client_batch.invocations.sort_by(&:index)
	end

	def update_from_client_result(result)
		self.client_guid = result['Guid']
		self.has_exited = result['HasExited']
		self.exit_code = result['ExitCode']
		self.standard_error = result['StandardError']
		self.standard_output = result['StandardOutput']
		save!
	end	

	def set_callback_token
		self.callback_token = Digest::SHA1.hexdigest([Time.now, rand].join)
	end
end
