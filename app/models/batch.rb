class Batch < ActiveRecord::Base
	belongs_to :user

	has_many :client_batches, dependent: :destroy
	has_many :steps, dependent: :destroy

	has_many :clients, through: :client_batches

	validates :name, presence: true
	validates :user, presence: true

	def start
		update(started: true)
		create_invocations

		#TODO... the reload smells but not sure what to do about it.
		#there's a problem only when we start the same batch multiple times from the same object reference (from console)
		#when you do that, the old invocations are cached and we end up trying to invoke those instead of the new ones.		
		steps.first.invocations.reload.each do |invocation|
			AwakenJob.perform_later invocation
		end
	end

	def create_client_batches(client_ids)
		client_ids.each {|client_id| client_batches.create(client_id: client_id)}
	end

	def started?
		started
	end
	
	def over?
		Util.over?(steps)
	end

	private

	def create_invocations
		client_batches.each do |cb|
			cb.create_invocations
		end
	end
end
