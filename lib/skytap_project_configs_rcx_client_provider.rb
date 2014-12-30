class SkytapProjectConfigsRcxClientProvider < RcxClientProvider
	has_display_name "Skytap: Configurations from Projects"	
	uses_user_setting :skytap_username, :skytap_api_token	

	def self.clients
		client_list = {}

		Skytap::Project.all.fetch.each do |project|
			client_list[project.name] = {}
			project.configurations.each do |config|
				client_list[project.name][config.name] = config.vms.map { |vm| vm.to_skytap_rcx_client }
			end
		end

		client_list
	end
end

#TODO RcxClientProvider, RcxClient, RcxClientAggregator into models?
#Create plug-in/generator for SkytapRcxClientProvider and friends