class SkytapUserConfigsRcxClientProvider < RcxClientProvider
	has_display_name "Skytap: My Configurations"	
	uses_user_setting :skytap_username, :skytap_api_token

	def self.clients
		client_list = {}

		Skytap::Configuration.all.fetch.each do |config|
			client_list[config.name] = config.vms.map { |vm| vm.to_skytap_rcx_client }
		end

		client_list
	end
end