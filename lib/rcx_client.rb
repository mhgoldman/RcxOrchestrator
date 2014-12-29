class RcxClient
	attr_reader :display_name
	attr_reader :agent_endpoint

	def initialize(opts={})
		@display_name = opts[:display_name]
		@agent_endpoint = RestClient::Resource.new(opts[:agent_endpoint_url])
	end

	def listening?
		begin
			@agent_endpoint['/ping'].get.downcase.include?('pong')
		rescue
			false
		end
	end

	def up?
		raise 'Not implemented'
	end

	def authorized?
		raise 'Not implemented'
	end

	def awaken!
		raise 'Not implemented'
	end
end

#TODO - Should this be a model from which SkytapRcxClient inherits?
#The user's list of available RcxClients is generated when he logs in, and also when he manually refreshes the list.
#When that happens, we call into all of his selected RcxClientProviders, generate the list, and store it.
#We then use the list to render the list of machines. But we'll also want to reference the items in the list by ID 
#later on. So yes, this should probably be a model.

#User HAS_MANY RcxClientProviders