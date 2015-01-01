class RcxClient < ActiveRecord::Base
	belongs_to :user
	validates :user, presence: true

	class << self
		attr_reader :display_name
	end

	def self.fetch_for_user!(user)
		new_clients = RcxClient.fetch_for_user(user)
		user.rcx_clients.destroy_all
		RcxClient.import new_clients
		user.rcx_clients.reload
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
			agent_endpoint['/ping'].get.downcase.include?('pong')
		rescue
			false
		end
	end

	### TODO

	def create_command(cmd, args)
	end

	def command_status(guid)
	end

	private

	def self.has_display_name(name)
		@display_name = name
	end

	def self.fetch_for_user(user)
		client_list = []

		# TODO: Need to do something about exceptions here. If one of the clienttypes breaks, that breaks the whole loop
		RcxOrchestrator::Application.config.rcx_client_types.each do |client_type|
			client_type_class = client_type.to_s.camelize.constantize
			clients_for_this_type = client_type_class.fetch_for_user(user)
			client_list |= clients_for_this_type
		end

		client_list
	end

	def agent_endpoint
		RestClient::Resource.new(@agent_endpoint_url)
	end
end
