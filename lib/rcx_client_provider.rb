class RcxClientProvider
	attr_reader :clients

	def get_clients
		raise 'Not implemented'
	end

	def initialize
		@clients = get_clients
	end
end