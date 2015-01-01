class RcxSkytap::Skytap::Vm
	include Her::Model

	belongs_to :configuration, class: RcxSkytap::Skytap::Configuration

	collection_path ":configuration_url/vms"

	def to_skytap_rcx_client_for_user(user)
		RcxSkytap::SkytapRcxClient.new( { display_name: "#{configuration.name}\\#{name}", user: user, skytap_vm_id: id,
			skytap_config_url: configuration_url, agent_endpoint_url: "http://#{interfaces.first['ip']}:8789/" } )
	end		
end