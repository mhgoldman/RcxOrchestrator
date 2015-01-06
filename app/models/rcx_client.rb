class RcxClient < ActiveRecord::Base
	has_and_belongs_to_many :batches	
	has_many :step_instances, dependent: :destroy
	belongs_to :user

	validates :user, presence: true

	validates :agent_endpoint_url, uniqueness: { scope: [:display_name, :user, :type] }

	class << self
		attr_reader :display_name
	end

	def self.fetch_for_user!(user)
		new_clients = RcxClient.fetch_for_user(user)
		user.rcx_clients = new_clients
		user.save
	end

	### "Abstract" (platform specific) Methods

	def up?
		raise 'Not implemented'
	end

	def authorized?
		raise 'Not implemented'
	end

	def awaken!
		raise 'Not implemented'
	end

	### RCX Agent Methods

	def listening?
		begin
			agent_endpoint['Rcx/ping'].get.downcase.include?('pong')
		rescue
			false
		end
	end

	def invoke_command(command)
		path = command.path
		args = command.args.is_a?(String) ? command.args.split : args 
		invoke_result_json = agent_endpoint['Rcx/commands'].post({path: path, args: args}.to_json, content_type: :json)
		JSON.parse(invoke_result_json)
	end

	def command_status(guid)
		invoke_result_json = agent_endpoint["Rcx/commands/#{guid}"].get
		JSON.parse(invoke_result_json)		
	end

	private

	def self.has_display_name(name)
		@display_name = name
	end

	def self.fetch_for_user(user)
		# algorithm: for each client in the new list, see if there's an existing RcxClient object that seems to represent the same client.
		# if so, keep the old one. if not, use the new one. clients that were on the old list but not on the new one will go away.
		# we have to do all this to ensure that existing clients' IDs don't change, as would screw up the database foreign keys and stuff.
		client_list = []

		RcxOrchestrator::Application.config.rcx_client_types.each do |client_type|
			old_clients = user.rcx_clients

			client_type_class_name = client_type.to_s.camelize
			client_type_class = client_type_class_name.constantize

			#begin
				clients_for_this_type = client_type_class.fetch_for_user(user)
				clients_for_this_type.each do |new_client|
					old_client = old_clients.find_by(display_name: new_client.display_name, agent_endpoint_url: new_client.agent_endpoint_url, type: client_type_class_name)
					client_list << (old_client || new_client)
				end
			#rescue
				#If an exception occurs while fetching clients of this type, just keep the old list of clients of this type.
				#TODO LOG ME!!
				#client_list |= old_clients
			#end
		end

		client_list
	end

	def agent_endpoint
		RestClient::Resource.new(agent_endpoint_url)
	end
end
