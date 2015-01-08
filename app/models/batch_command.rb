class BatchCommand < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :client_batch_commands, dependent: :destroy
	before_validation :set_index

	validates :index, presence: true, uniqueness: { scope: :batch }

	def over?
		client_batch_commands.each {|cbc| return false unless cbc.over? }
		true
	end

	def client_batch_commands_count_by_status
		counts = {}
		ClientBatchCommand::STATUSES.each do |status|
			counts[status] = client_batch_commands.select {|cbc| cbc.status == status }.count
		end

		counts
	end

	private

	def set_index
		if index.nil?
			#TODO!!!
			self.index = ((batch.batch_commands.map {|bc| bc.index}).max || 0) + 1
			puts "!!!!!!! Index #{index}!!!!!!!"
		end
	end
end
