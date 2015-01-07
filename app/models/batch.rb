class Batch < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :rcx_clients
	has_many :batch_commands, dependent: :destroy

	validates :name, presence: true
	validates :user, presence: true

	def start
		generate_client_batch_commands

		batch_commands.first.client_batch_commands.each do |client_batch_command|
			AwakenJob.perform_later client_batch_command
		end
	end

	def finished?
		rcx_clients.each {|rcx_client| return false unless finished_for_rcx_client?(rcx_client)}
		true
	end

	def finished_for_rcx_client?(rcx_client)
		statuses = rcx_client_client_batch_commands_count_by_status(rcx_client)
		statuses[:finished] == batch_commands.count || statuses[:error] > 0
	end	

	def client_batch_commands_by_rcx_client(rcx_client)
		batch_commands.map {|batch_command| ClientBatchCommand.find_by(batch_command: batch_command, rcx_client: rcx_client) }
	end

	def rcx_client_client_batch_commands_count_by_status(rcx_client)
		counts = {}
		ClientBatchCommand::STATUSES.each do |status|
			client_batch_commands = client_batch_commands_by_rcx_client(rcx_client)
			counts[status] = client_batch_commands.select {|si| si.status == status }.count
		end

		counts		
	end

	private
	
	def generate_client_batch_commands
		# call immediately prior to beginning the batch
		batch_commands.each do |batch_command|
			batch_command.client_batch_commands.destroy_all				
			rcx_clients.each do |rcx_client|
				batch_command.client_batch_commands.create(rcx_client: rcx_client)
			end
		end
	end
end
