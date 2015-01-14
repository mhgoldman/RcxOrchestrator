class Batch < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :clients
	has_many :steps, dependent: :destroy

	validates :name, presence: true
	validates :user, presence: true

	def start
		update(started: true)
		generate_client_steps
		steps.first.client_steps.each do |client_step|
			AwakenJob.perform_later client_step
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
		client_steps_by_client(client).each {|cbc| return false unless cbc.over? }
		true
	end

	def client_client_steps_count_by_status(client)
		counts = {}
		ClientStep::STATUSES.each do |status|
			client_steps = client_steps_by_client(client)
			counts[status] = client_steps.select {|cbc| cbc.status == status }.count
		end

		counts		
	end

	def client_steps_by_client(client)
		steps.map {|step| ClientStep.find_by(step: step, client: client) }
	end

	private
	
	def generate_client_steps
		steps.each do |step|
			step.client_steps.destroy_all				
			clients.each do |client|
				step.client_steps.create(client: client)
			end
		end
	end
end
