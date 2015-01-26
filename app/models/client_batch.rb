class ClientBatch < ActiveRecord::Base
	belongs_to :client
	belongs_to :batch
	has_many :invocations, dependent: :destroy
	
	def over?
		Util.over?(invocations)
	end

	def invocations_count_by_status
		counts = {}
		Invocation::STATUSES.each do |status|
			counts[status] = invocations.select {|cbc| cbc.status == status }.count
		end

		counts		
	end

	def self.get(client, batch)
		find_by(client: client, batch: batch)
	end

	def create_invocations
		invocations.destroy_all

		batch.steps.each do |step|
			invocations.create(step: step)
		end
	end
end
