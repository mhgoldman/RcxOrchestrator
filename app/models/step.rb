class Step < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :step_instances, dependent: :destroy

	validates :index, presence: true, uniqueness: { scope: :batch }

	def finished?
		step_instances.each {|si| return false unless si.finished? }
		true
	end

	def finished_for_rcx_client?(rcx_client)
		rcx_client.step_instances.find_by(step: self).finished?
	end
end
