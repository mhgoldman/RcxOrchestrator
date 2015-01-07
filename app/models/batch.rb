class Batch < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :rcx_clients
	has_many :steps, dependent: :destroy

	validates :name, presence: true
	validates :user, presence: true

	def start
		generate_step_instances

		steps.first.step_instances.each do |step_instance|
			StepInstanceJob.perform_later step_instance
		end
	end

	def finished?
		rcx_clients.each {|rcx_client| return false unless finished_for_rcx_client?(rcx_client)}
		true
	end

	def finished_for_rcx_client?(rcx_client)
		statuses = rcx_client_step_instances_count_by_status(rcx_client)
		statuses[:finished] == steps.count || statuses[:error] > 0
	end	

	def step_instances_by_rcx_client(rcx_client)
		steps.map {|step| StepInstance.find_by(step: step, rcx_client: rcx_client) }
	end

	def rcx_client_step_instances_count_by_status(rcx_client)
		counts = {}
		StepInstance::STATUSES.each do |status|
			step_instances = step_instances_by_rcx_client(rcx_client)
			counts[status] = step_instances.select {|si| si.status == status }.count
		end

		counts		
	end

	private
	
	def generate_step_instances
		# call immediately prior to beginning the batch
		steps.each do |step|
			step.step_instances.destroy_all				
			rcx_clients.each do |rcx_client|
				step.step_instances.create(rcx_client: rcx_client)
			end
		end
	end
end
