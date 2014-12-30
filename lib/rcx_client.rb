class RcxClient
	attr_reader :display_name
	attr_reader :agent_endpoint_url	

	def initialize(opts={})
		raise "#{self.class} cannot be directly instantiated" if self.class == RcxClient
		@display_name = opts[:display_name]
		@agent_endpoint_url = opts[:agent_endpoint_url]
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

	def agent_endpoint
		RestClient::Resource.new(@agent_endpoint_url)
	end
end