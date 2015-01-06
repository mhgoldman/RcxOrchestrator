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
		steps.each {|step| return false unless step.finished? }
		true
	end

	def finished_for_rcx_client?(rcx_client)
		steps.each {|step| return false unless step.finished_for_rcx_client?(rcx_client)}
		true
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
