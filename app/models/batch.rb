class Batch < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :clients
	has_many :batch_commands, dependent: :destroy

	validates :name, presence: true
	validates :user, presence: true

	def start
		update(started: true)
		generate_client_batch_commands
		batch_commands.first.client_batch_commands.each do |client_batch_command|
			AwakenJob.perform_later client_batch_command
		end
	end

	def started?
		started
	end
	
	def over?
		batch_commands.each {|batch_command| return false unless batch_command.over? }
		true
	end

	def over_for_client?(client)
		client_batch_commands_by_client(client).each {|cbc| return false unless cbc.over? }
		true
	end

	def client_client_batch_commands_count_by_status(client)
		counts = {}
		ClientBatchCommand::STATUSES.each do |status|
			client_batch_commands = client_batch_commands_by_client(client)
			counts[status] = client_batch_commands.select {|cbc| cbc.status == status }.count
		end

		counts		
	end

	def client_batch_commands_by_client(client)
		batch_commands.map {|batch_command| ClientBatchCommand.find_by(batch_command: batch_command, client: client) }
	end

	private
	
	def generate_client_batch_commands
		batch_commands.each do |batch_command|
			batch_command.client_batch_commands.destroy_all				
			clients.each do |client|
				batch_command.client_batch_commands.create(client: client)
			end
		end
	end
end
