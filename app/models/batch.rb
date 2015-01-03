class Batch < ActiveRecord::Base
	validates :name, presence: true
	belongs_to :user
	validates :user, presence: true
	has_and_belongs_to_many :rcx_clients
	has_many :steps, dependent: :destroy

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
