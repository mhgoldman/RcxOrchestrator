class BatchCommand < ActiveRecord::Base
	belongs_to :batch
	belongs_to :command
	has_many :client_batch_commands, dependent: :destroy

	validates :index, presence: true, uniqueness: { scope: :batch }

	def finished?
		client_batch_commands.each {|si| return false unless si.finished? || batch.finished_for_rcx_client?(si.rcx_client)}
		true
	end

	def client_batch_commands_count_by_status
		counts = {}
		ClientBatchCommand::STATUSES.each do |status|
			counts[status] = client_batch_commands.select {|si| si.status == status }.count
		end

		counts
	end
end
