class Step < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :step_instances, dependent: :destroy

	validates :index, presence: true, uniqueness: { scope: :batch }

	def finished?
		step_instances.each {|si| return false unless si.finished? || batch.finished_for_rcx_client?(si.rcx_client)}
		true
	end

	def step_instances_count_by_status
		counts = {}
		StepInstance::STATUSES.each do |status|
			counts[status] = step_instances.select {|si| si.status == status }.count
		end

		counts
	end
end
