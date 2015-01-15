class Batch < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :clients
	has_many :steps, dependent: :destroy

	validates :name, presence: true
	validates :user, presence: true

	def start
		update(started: true)
		generate_invocations
		steps.first.invocations.each do |invocation|
			AwakenJob.perform_later invocation
		end
	end

	def started?
		started
	end
	
	def over?
		steps.each {|step| return false unless step.over? }
		true
	end

	def over_for_client?(client)
		invocations_by_client(client).each {|cbc| return false unless cbc.over? }
		true
	end

	def client_invocations_count_by_status(client)
		counts = {}
		Invocation::STATUSES.each do |status|
			invocations = invocations_by_client(client)
			counts[status] = invocations.select {|cbc| cbc.status == status }.count
		end

		counts		
	end

	def invocations_by_client(client)
		steps.map {|step| Invocation.find_by(step: step, client: client) }
	end

	private
	
	def generate_invocations
		steps.each do |step|
			step.invocations.destroy_all				
			clients.each do |client|
				step.invocations.create(client: client)
			end
		end
	end
end
