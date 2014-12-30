class RcxClient
	class << self
		attr_reader :user_settings, :display_name
	end

	attr_reader :display_name, :agent_endpoint_url	

	def initialize(opts={})
		raise "#{self.class} cannot be directly instantiated" if self.class == RcxClient
		@display_name = opts[:display_name]
		@agent_endpoint_url = opts[:agent_endpoint_url]
	end

	### Class Methods

	def self.all
		client_list = {}

		# TODO: Need to do something about exceptions here. If one of the clienttypes breaks, then none of them run
		RcxOrchestrator::Application.config.rcx_client_types.each do |client_type|
			client_type_class = client_type.to_s.camelize.constantize
			client_list[client_type_class.display_name] = client_type_class.all
		end

		client_list
	end

	### "Abstract" Methods

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

	#TODO: Can we share objects with the agent? (Do we want to?)
	def create_command(cmd, args)
	end

	def command_status(guid)
	end

	private

	### "DSL" methods

	def self.uses_user_setting(*args)
		@user_settings ||= []
		@user_settings |= args
	end

	def self.has_display_name(name)
		@display_name = name
	end

	## Other helpers

	def agent_endpoint
		RestClient::Resource.new(@agent_endpoint_url)
	end
end