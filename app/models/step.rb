class Step < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :client_steps, dependent: :destroy
	before_validation :set_index

	validates :index, presence: true, uniqueness: { scope: :batch }

	def over?
		client_steps.each {|cbc| return false unless cbc.over? }
		true
	end

	def client_steps_count_by_status
		counts = {}
		ClientStep::STATUSES.each do |status|
			counts[status] = client_steps.select {|cbc| cbc.status == status }.count
		end

		counts
	end

	private

	def set_index
		if index.nil?
			self.index = ((batch.steps.map {|bc| bc.index}).max || -1	) + 1
		end
	end
end
