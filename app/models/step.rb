class Step < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :invocations, dependent: :destroy
	before_validation :set_index

	validates :index, presence: true, uniqueness: { scope: :batch }

	def over?
		invocations.each {|cbc| return false unless cbc.over? }
		true
	end

	def invocations_count_by_status
		counts = {}
		Invocation::STATUSES.each do |status|
			counts[status] = invocations.select {|cbc| cbc.status == status }.count
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
