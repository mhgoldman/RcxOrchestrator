class SkytapRcxClientProvider < RcxClientProvider
	def get_clients
		client_list = {}

		client_list['My Configurations'] = {}
		Skytap::Configuration.all.fetch.each do |config|
			client_list['My Configurations'][config.name] = []
			config.vms.each do |vm|				
				opts = { display_name: vm.name, skytap_vm_id: vm.id, skytap_config_url: vm.configuration_url, 
					agent_endpoint_url: "http://#{vm.interfaces.first['ip']}:8789/" }

				client_list['My Configurations'][config.name] << SkytapRcxClient.new(opts)
			end
		end

		client_list['Configurations from Projects'] = {}
		Skytap::Project.all.fetch.each do |project|
			client_list['Configurations from Projects'][project.name] = {}
			project.configurations.each do |config|
				client_list['Configurations from Projects'][project.name][config.name] = []
				config.vms.each do |vm|
					opts = { display_name: vm.name, skytap_vm_id: vm.id, skytap_config_url: vm.configuration_url, 
						agent_endpoint_url: "http://#{vm.interfaces.first['ip']}:8789/" }
	
					client_list['Configurations from Projects'][project.name][config.name] << SkytapRcxClient.new(opts)
				end
			end
		end

		client_list
	end
end