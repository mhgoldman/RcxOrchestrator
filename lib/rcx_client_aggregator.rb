class RcxClientAggregator
	def initialize
		raise "#{self.class} cannot be instantiated"
	end

	def self.clients
		client_list = {}

		Rails.application.config.rcx_client_providers.map do |provider_name|
			provider = provider_name.to_s.camelize.constantize
			client_list[provider.display_name] = provider.clients
		end

		client_list
	end
end